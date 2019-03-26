import 'package:house/importLib.dart';

class DataUtils {
  const DataUtils();

  static List isList(dynamic json) {
    if (json == null) {
      return [];
    } else if (json is List) {
      return json;
    } else {
      return [];
    }
  }

  static Map<String, dynamic> isMap(dynamic json) {
    if (json == null) {
      return {};
    } else if (json is Map<String, dynamic>) {
      return json;
    } else {
      return {};
    }
  }

  static bool isEmpty(String value) {
    return value == null || value.isEmpty;
  }

  static bool isEmptyList(List value) {
    return value == null || value.isEmpty;
  }

  static T getFirst<T>(List<T> data) {
    if (DataUtils.isEmptyList(data)) {
      return null;
    } else {
      return data.first;
    }
  }

  static String getFirstImage(List<ImageData> data) {
    var a = getFirst(data);
    String url = HttpManager.BASE_URL + (a?.picUrl ?? "");
    return url;
  }

  static String getImageUrl(String imageUrl) {
    if (DataUtils.isEmpty(imageUrl)) {
      return "";
    } else if (imageUrl.startsWith("http://") ||
        imageUrl.startsWith("https://")) {
      return imageUrl;
    } else {
      return HttpManager.BASE_URL + (imageUrl ?? "");
    }
  }

  static bool checkEmail(String email) {
    return RegExp(
            "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}")
        .hasMatch(email);
  }
}
