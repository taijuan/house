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
  GoogleMapController _googleMapController;
  LatLng _latLng;
  List<LatLonHouse> _data = [];

  @override
  void initState() {
    super.initState();
    PermissionHandler().requestPermissions([
      PermissionGroup.location,
    ]).then((values) {
      return values.values.every((status) {
        return status == PermissionStatus.granted;
      });
    }).then((granted) {
      if (granted) {
        _initLocation();
      } else {
        pop(context);
      }
    });
    queryHouse();
  }

  void queryHouse() {
    showLoadingDialog(context);
    queryHouseLocal(
      context,
      cancelToken: cancelToken,
    ).then((data) {
      if (data != null) {
        this._data.clear();
        this._data.addAll(data);
        pop(context);
        _addMarkers();
      }
    });
  }

  _initLocation() {
    Location().getLocation().then((data) {
      if (data != null) {
        _latLng = LatLng(data.latitude, data.longitude);
        _addMarkers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
      onMapCreated: _onMapCreated,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    _googleMapController.onMarkerTapped.add(_getHouse);
    _addMarkers();
  }

  void _addMarkers() {
    if (_googleMapController == null) return;
    _googleMapController.clearMarkers();
    _data.forEach((v) {
      var marker = MarkerOptions.defaultOptions.copyWith(
        MarkerOptions(
          icon: v.repairStatus.value == TypeStatus.houseOngoing.value
              ? BitmapDescriptor.fromAsset("image/house_marker_red.webp")
              : BitmapDescriptor.fromAsset("image/house_marker_green.webp"),
          position: LatLng(double.tryParse(v.latitude) ?? 0.0,
              double.tryParse(v.longitude) ?? 0.0),
        ),
      );
      _googleMapController.addMarker(marker).then((marker) {
        LogUtils.log("zuiweng     ${marker.id}");
        v.markerId = marker.id;
      });
    });
    if (_latLng != null) {
      var marker = MarkerOptions.defaultOptions.copyWith(
        MarkerOptions(
          icon: BitmapDescriptor.defaultMarker,
          position: _latLng,
        ),
      );
      _googleMapController.addMarker(marker);
      _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          _latLng,
          10,
        ),
      );
    }
  }

  void _getHouse(Marker marker) {
    showLoadingDialog(context);
    LatLonHouse a = _data.firstWhere((v) {
      return v.markerId == marker.id;
    }, orElse: () {
      return null;
    });
    if (a == null) {
      pop(context);
      return;
    }
    houseDetail(
      context,
      a.houseId,
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
      pop(context);
    });
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }
}
