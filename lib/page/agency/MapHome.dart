import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house/importLib.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MapHome extends BaseStatefulWidget {
  @override
  MapHomeState createState() => MapHomeState();

  MapHome({Key key}) : super(key: key);
}

class MapHomeState extends BaseState<MapHome> {
  List<LatLonHouse> _data = [];
  List<Marker> _markers = [];

  void _getPermission(GoogleMapController controller) {
    PermissionHandler().requestPermissions([
      PermissionGroup.location,
    ]).then((values) {
      return values.values.every((status) {
        return status == PermissionStatus.granted;
      });
    }).then((granted) {
      _initLocation(controller);
    });
  }

  void queryHouse() {
    showLoadingDialog(context);
    queryHouseLocal(
      context,
      cancelToken: cancelToken,
    )
      ..then((data) {
        if (data != null) {
          this._data.clear();
          this._data.addAll(data);
          pop(context);
          _addMarkers();
        }
      })
      ..catchError((e) {
        showToast(context, e.toString());
        pop(context);
      });
  }

  _initLocation(GoogleMapController controller) {
    Location().getLocation().then((data) {
      if (data != null) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(data.latitude, data.longitude)),
          ),
        );
        queryHouse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(33.8688197000, 151.2092955000),
      ),
      onMapCreated: _getPermission,
      myLocationEnabled: true,
      markers: _markers.toSet(),
    );
  }

  void _addMarkers() {
    _markers.clear();
    _data.forEach((v) {
      var marker = Marker(
        markerId: MarkerId(v.houseId),
        position: LatLng(
          double.tryParse(v.latitude) ?? 0.0,
          double.tryParse(v.longitude) ?? 0.0,
        ),
        icon: v.repairStatus.value == TypeStatus.houseOngoing.value
            ? BitmapDescriptor.fromAsset("image/house_marker_red.webp")
            : BitmapDescriptor.fromAsset("image/house_marker_green.webp"),
        onTap: () {
          _getHouse(v.houseId);
        },
      );
      _markers.add(marker);
    });
    setState(() {});
  }

  void _getHouse(String houseId) {
    showLoadingDialog(context);
    houseDetail(
      context,
      houseId,
      cancelToken: cancelToken,
    ).then((house) {
      pop(context);
      showContentDialog(
        context,
        barrierDismissible: true,
        alignment: AlignmentDirectional.bottomCenter,
        margin: EdgeInsets.all(12),
        child: HouseBigCard(house),
      );
    }).catchError((e) {
      showToast(context, e.toString());
      pop(context);
    });
  }
}
