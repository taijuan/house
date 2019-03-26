import 'package:house/importLib.dart';

class OrderDetail {
  Order repairOrder;
  Question questionInfo;
  House house;
  Quotation repairQuote;
  List<Message> repairMessages;
  List<OrderLogs> repairOrderLogs;
  List<RepairResult> repairQuoteResults;

  OrderDetail.fromJson(Map<String, dynamic> json) {
    repairOrder = Order.fromJson(json["repairOrder"]);
    questionInfo = Question.fromJson(json["questionInfo"]);
    house = House.fromJson(json["house"]);
    repairQuote = json["repairQuote"] == null
        ? null
        : Quotation.fromJson(json["repairQuote"]);
    repairMessages = DataUtils.isList(json["repairMessages"]).map((v) {
      return Message.fromJson(v);
    }).toList();
    repairOrderLogs = DataUtils.isList(json["repairOrderLogs"]).map((v) {
      return OrderLogs.fromJson(v);
    }).toList();
    repairQuoteResults = DataUtils.isList(json["repairQuoteResults"]).map((v) {
      return RepairResult.fromJson(v);
    }).toList();
  }
}
