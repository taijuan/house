import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui show instantiateImageCodec, Codec;
import 'dart:ui';

class FileUtils {
  const FileUtils();

  static Future<String> compressWithFileToBase64(File file) async {
    try {
      if (file == null) {
        return null;
      } else if (!await file.exists()) {
        return null;
      } else {
        List<int> bytes = await file.readAsBytes();
        ui.Codec codec = await ui.instantiateImageCodec(
          bytes,
          targetWidth: 540,
          targetHeight: 960,
        );
        if (codec.frameCount > 1) {
          var c = base64.encode(bytes);
          return c;
        } else {
          var a = await codec.getNextFrame();
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
