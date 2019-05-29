import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui show instantiateImageCodec, Codec;
import 'dart:ui';

class FileUtils {
  const FileUtils();

  static Future<String> compressWithFileToBase64(
    File file, {
    int width = 540,
    int height = 960,
  }) async {
    try {
      if (file == null) {
        return null;
      } else if (!await file.exists()) {
        return null;
      } else {
        List<int> bytes = await file.readAsBytes();
        ui.Codec codec = await ui.instantiateImageCodec(bytes);
        if (codec.frameCount > 1) {
          var c = base64.encode(bytes);
          return c;
        } else {
          var a = await codec.getNextFrame();
          int w = a.image.width;
          int h = a.image.height;
          double wd = w / width.toDouble();
          double hd = h / height.toDouble();
          double be = 1;
          if (wd >= 1 && hd >= 1) {
            be = wd >= hd ? wd : hd;
          }
          codec = await ui.instantiateImageCodec(bytes,
              targetWidth: w ~/ be, targetHeight: h ~/ be);
          a = await codec.getNextFrame();
          var b = await a.image.toByteData(format: ImageByteFormat.png);
          var c = base64.encode(b.buffer.asUint8List());
          return c;
        }
      }
    } catch (e) {
      return null;
    }
  }
}
