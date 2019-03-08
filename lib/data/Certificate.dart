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
  dynamic status;

  Certificate.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    type = json["type"];
    typeName = json["typeName"];
    endDate = json["endDate"];
    certificateNo = json["certificateNo"];
    picUrl = json["picUrl"];
    thumbUrl = json["thumbUrl"];
    status = json["status"];
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
