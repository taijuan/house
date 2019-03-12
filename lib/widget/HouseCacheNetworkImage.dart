import 'package:cached_network_image/cached_network_image.dart';
import 'package:house/importLib.dart';

class HouseCacheNetworkImage extends StatelessWidget {
  static const AssetImage placeholder =
      AssetImage("image/house_loading_image_placeholder.webp");
  final String data;
  final double aspectRatio;
  final double width;
  final double height;
  final BoxFit fit;

  const HouseCacheNetworkImage(
    this.data, {
    this.aspectRatio,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (aspectRatio == null) {
      return FadeInImage(
        width: width,
        height: height,
        image: CachedNetworkImageProvider(data),
        placeholder: placeholder,
        fit: fit,
      );
    } else {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: FadeInImage(
          image: CachedNetworkImageProvider(data),
          placeholder: placeholder,
          fit: fit,
        ),
      );
    }
  }
}
