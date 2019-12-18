import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
    return ExtendedImage.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.fill,
      cache: true,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Image.asset(
              "image/house_loading_image_placeholder.webp",
              fit: fit,
            );
          case LoadState.failed:
            return Image.asset(
              "image/house_loading_image_placeholder.webp",
              fit: fit,
            );
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              width: width,
              height: height,
              fit: fit,
            );
        }
        return Container();
      },
    );
  }
}
