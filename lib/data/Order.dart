import 'package:house/importLib.dart';

class Order {
  String id;
  String typeNames;
  TypeStatus status;
  TypeStatus repairQuoteStatus;
  String repairQuoteId;
  String questionId;
  String title;
  String desc;
  String orderNo;
  String address;
  ImageContent photos;
  String transactor;
  String resultDesc;
  String createTime;

  Order.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    typeNames = json["typeNames"] ?? "";
    status = TypeStatus.fromJson(DataUtils.isMap(json["status"]));
    repairQuoteStatus =
        TypeStatus.fromJson(DataUtils.isMap(json["repairQuoteStatus"]));
    repairQuoteId = json["repairQuoteId"];
    questionId = json["questionId"];
    title = json["title"] ?? "";
    desc = json["desc"];
    orderNo = json["orderNo"] ?? "";
    address = json["address"];
    photos = ImageContent.fromJson(DataUtils.isMap(json["photos"]));
    transactor = json["transactor"];
    resultDesc = json["resultDesc"] ?? "";
  }
}
