import 'package:house/importLib.dart';

class RepairResult {
  String id;
  String quoteId;
  ImageContent image;
  String resultDesc;
  String createTime;

  RepairResult.fromJson(Map<String, dynamic> json) {
    id = json["is"];
    quoteId = json["quoteId"];
    image = ImageContent.fromJson(json["image"]);
    resultDesc = json["resultDesc"] ?? "";
    createTime = json["createTime"];
  }
}
