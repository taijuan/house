import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:house/utils/LogUtils.dart';

class FileUtils {
  const FileUtils();

  static Future<String> compressWithFileToBase64(File file) async {
    if (file == null) {
      return null;
    } else {
      String path = file.absolute.path;
      LogUtils.log(path);
      List<int> a = await FlutterImageCompress.compressWithFile(
        path,
        minWidth: 540,
        minHeight: 960,
        quality: 75,
      );
      String b = base64.encode(a);
      LogUtils.log(b);
      return b;
    }
  }
}
