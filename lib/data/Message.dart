import 'package:house/importLib.dart';

class Message {
  String id;
  String repairOrderId;
  String message;
  String sendUserId;
  String receiveUserId;
  String createTime;
  String lastName;
  String firstName;
  String headImg;
  TypeStatus userType;
  TypeStatus receiveUserType;

  Message.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    repairOrderId = json["repairOrderId"];
    message = json["message"];
    sendUserId = json["sendUserId"];
    receiveUserId = json["receiveUserId"];
    createTime = json["createTime"] ?? "";
    lastName = json["lastName"];
    firstName = json["firstName"];
    headImg = json["headImg"];
    userType = TypeStatus.fromJson(DataUtils.isMap(json["userType"]));
    receiveUserType =
        TypeStatus.fromJson(DataUtils.isMap(json["receiveUserType"]));
  }
}
