import 'package:house/importLib.dart';

class LatLonHouse {
  String longitude;
  String latitude;
  TypeStatus repairStatus;
  String houseId;
  String markerId;

  LatLonHouse.fromJson(Map<String, dynamic> json) {
    this.longitude = json["longitude"];
    this.latitude = json["latitude"];
    this.repairStatus =
        TypeStatus.fromJson(DataUtils.isMap(json["repairStatus"]));
    this.houseId = json["houseId"];
  }
}