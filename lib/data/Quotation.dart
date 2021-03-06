import 'package:house/importLib.dart';

class Quotation {
  String id;
  String userId;
  double price;
  String repairOrderId;
  String desc;
  TypeStatus status;
  String lastName;
  String firstName;
  String headImg;

  Quotation.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"];
    price = json["price"];
    repairOrderId = json["repairOrderId"];
    desc = json["desc"];
    status = TypeStatus.fromJson(DataUtils.isMap(json["status"]));
    lastName = json["lastName"];
    firstName = json["firstName"];
    headImg = json["headImg"];
  }
}
