import 'package:house/importLib.dart';

class Certificate {
  String id;
  String type;
  String typeName;
  String endDate;
  String thumbUrl;
  String picUrl;
  String certificateNo;
  File imgStr;
  String imageName;
  //  待审核(0, "待审核"),
  //	审核通过(1, "审核通过"),
  //	即将过期(2, "即将过期"),
  //  过期(3, "过期"),
  //  删除(4, "删除")
  TypeStatus status;

  Certificate.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    type = json["type"];
    typeName = json["typeName"];
    endDate = json["endDate"];
    certificateNo = json["certificateNo"];
    picUrl = json["picUrl"];
    thumbUrl = json["thumbUrl"];
    status = TypeStatus.fromJson(json["status"] ?? {});
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "typeName": typeName,
        "endDate": endDate,
        "thumbUrl": thumbUrl,
        "picUrl": picUrl,
        "certificateNo": certificateNo,
        "status": status,
      };
}
