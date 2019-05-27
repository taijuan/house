import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Codec, instantiateImageCodec;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheImage extends StatelessWidget {
  final String imageUrl;
  final double width, height;
  final BoxFit fit;

  const CacheImage(
    this.imageUrl, {
    Key key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      image: CacheNetworkImage(
        imageUrl,
      ),
      placeholder: AssetImage("image/house_loading_image_placeholder.webp"),
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
    );
  }
}

class CacheNetworkImage extends ImageProvider<CacheNetworkImage> {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments must not be null.
  const CacheNetworkImage(
    this.url, {
    this.scale = 1.0,
  })  : assert(url != null),
        assert(scale != null);

  /// The URL from which the image will be fetched.
  final String url;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  @override
  Future<CacheNetworkImage> obtainKey(ImageConfiguration configuration) {
    print("configuration ${configuration.size}");
    return SynchronousFuture<CacheNetworkImage>(this);
  }

  @override
  ImageStreamCompleter load(CacheNetworkImage key) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: key.scale,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>('Image provider', this);
        yield DiagnosticsProperty<CacheNetworkImage>('Image key', key);
      },
    );
  }

  Future<ui.Codec> _loadAsync(
    CacheNetworkImage key,
  ) async {
    assert(key == this);
    File file = await DefaultCacheManager().getSingleFile(
      key.url,
    );
    if (file == null || !await file.exists()) {
      return null;
    } else {
      Uint8List bytes = await file.readAsBytes();
      if (bytes == null || bytes.length == 0) {
        return null;
      }
      return await ui.instantiateImageCodec(
        bytes,
      );
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final CacheNetworkImage typedOther = other;
    return url == typedOther.url && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(url, scale);

  @override
  String toString() => '$runtimeType("$url", scale: $scale)';
}
