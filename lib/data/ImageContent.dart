import 'package:house/importLib.dart';
class ImageContent {
  List<ImageData> content;

  ImageContent.fromJson(Map<String, dynamic> json)
      : content = _getList(DataUtils.isList(json["content"]));

  static List<ImageData> _getList(List<dynamic> list) {
    return list.map((json) {
      return ImageData.fromJson(json);
    }).toList();
  }
}