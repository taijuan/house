import 'package:house/importLib.dart';

class Question {
  String id;
  String description;
  String houseId;
  TypeStatus status;
  ImageContent photos;
  String createDate;
  String updateDate;
  String userId;

  Question.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        description = json["description"],
        houseId = json["houseId"],
        status = TypeStatus.fromJson(DataUtils.isMap(json["status"])),
        photos = ImageContent.fromJson(DataUtils.isMap(json["photos"])),
        createDate = json["createDate"],
        updateDate = json["updateDate"],
        userId = json["userId"];

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "houseId": houseId,
    "status": status,
    "photos": photos,
    "createDate": createDate,
    "updateDate": updateDate,
    "userId": userId,
  };
}