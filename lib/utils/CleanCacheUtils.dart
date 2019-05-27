import 'package:house/importLib.dart';

class CleanCacheUtils {
  const CleanCacheUtils();

  static Future<int> getFileSizes(Directory d) async {
    int size = 0;
    await for (var file in d.list()) {
      String path = file.path;
      if (await FileSystemEntity.isFile(path)) {
        size += await File(path).length();
      } else {
        size += await getFileSizes(Directory(path));
      }
    }
    return size;
  }

  static Future<String> formatCacheFileSize({int fractionDigits: 2}) async {
    Directory d = await getApplicationDocumentsDirectory();
    int size = await getFileSizes(d);
    if (size <= 0) {
      return "0.00b";
    } else if (size < 1024) {
      return "${size.toStringAsFixed(fractionDigits)}b";
    } else if (size < 1024 * 1024) {
      return "${(size / 1024).toStringAsFixed(fractionDigits)}kb";
    } else if (size < 1024 * 1024 * 1024) {
      return "${(size * 1.00 / 1024 / 1024).toStringAsFixed(fractionDigits)}mb";
    } else {
      return "${(size * 1.00 / 1024 / 1024 / 1024).toStringAsFixed(fractionDigits)}gb";
    }
  }

  static Future<Null> clearCache() async {
    await (await getTemporaryDirectory()).delete(recursive: true);
  }
}
