import 'package:extended_image/extended_image.dart';
import 'package:house/importLib.dart';

houseCacheNetworkImage(
  String data, {
  double width = double.infinity,
  double height = double.infinity,
  BoxFit fit = BoxFit.cover,
}) {
  return ExtendedImage.network(
    data,
    key: ValueKey(data),
    fit: fit,
    width: width,
    height: height,
    borderRadius: BorderRadius.circular(4),
    shape: BoxShape.rectangle,
    loadStateChanged: (state) {
      switch (state.extendedImageLoadState) {
        case LoadState.loading:
        case LoadState.failed:
          return ExtendedImage.asset(
            "image/house_loading_image_placeholder.webp",
            width: width,
            height: height,
            fit: fit,
          );
          break;
        case LoadState.completed:
          return ExtendedRawImage(
            image: state.extendedImageInfo?.image,
            width: width,
            height: height,
            fit: fit,
          );
      }
    },
  );
}
