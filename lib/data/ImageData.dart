class ImageData {
  String name;
  String picUrl;
  String picBigUrl;
  String type;

  ImageData.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        picUrl = json["picUrl"] ?? "",
        picBigUrl = json["picBigUrl"] ?? "",
        type = json["type"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "picUrl": picUrl,
        "picBigUrl": picBigUrl,
        "type": type,
      };
}
