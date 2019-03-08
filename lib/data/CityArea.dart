import 'package:house/importLib.dart';

class CityArea {
  String id;
  String name;
  String pid;
  List<CityArea> districtList;
  bool checked;

  CityArea.fromJson(Map<String, dynamic> json) {
    id = (json["id"]?.toString()) ?? json["districtId"];
    name = json["name"] ?? json["cityName"];
    pid = (json["pid"]?.toString()) ?? json["cityId"];
    districtList = DataUtils.isList(json["districtList"]).map((json) {
      return CityArea.fromJson(json);
    }).toList();
    checked = json["checked"] ?? false;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pid": pid,
        "districtList": districtList,
        "checked": checked
      };
}
