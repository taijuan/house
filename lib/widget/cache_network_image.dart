import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:http_client_helper/http_client_helper.dart';

class CacheImage extends StatefulWidget {
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
  CacheImageState createState() => CacheImageState();
}

class CacheImageState extends State<CacheImage> {
  final CancellationToken cancelToken = CancellationToken();

  @override
  void dispose() {
    if (!cancelToken.isCanceled) {
      cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExtendedImage.network(
        widget.imageUrl,
        key: ValueKey(widget.imageUrl),
        fit: widget.fit ?? BoxFit.cover,
        width: widget.width,
        height: widget.height,
        cancelToken: cancelToken,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
            case LoadState.failed:
              return ExtendedImage.asset(
                "image/house_loading_image_placeholder.webp",
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
              );
              break;
            case LoadState.completed:
              return ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
              );
          }
        },
      );
}
