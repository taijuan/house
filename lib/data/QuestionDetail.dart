import 'package:house/importLib.dart';

class QuestionDetail {
  List<Order> repairOrders;
  Question questionInfo;
  House house;

  QuestionDetail.fromJson(Map<String, dynamic> json)
      : repairOrders = DataUtils.isList(json["repairOrders"]).map((json) {
          return Order.fromJson(json);
        }).toList(),
        questionInfo = Question.fromJson(DataUtils.isMap(json["questionInfo"])),
        house = House.fromJson(DataUtils.isMap(json["house"]));
}
