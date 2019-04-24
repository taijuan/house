import 'package:extended_image/extended_image.dart';
import 'package:house/importLib.dart';

class ImagePageView extends BaseStatefulWidget {
  final List<String> data;

  ImagePageView(this.data);

  @override
  _ImagePageViewState createState() => _ImagePageViewState();
}

class _ImagePageViewState extends BaseState<ImagePageView> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          ExtendedImageGesturePageView.builder(
            itemBuilder: (context, index) {
              return CacheImage(DataUtils.getImageUrl(widget.data[index]));
            },
            itemCount: widget.data.length,
            controller: PageController(initialPage: index),
            onPageChanged: (index) {
              setState(() {
                this.index = index;
              });
            },
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              padding: EdgeInsets.fromLTRB(4, 1, 4, 3),
              decoration: BoxDecoration(
                color: HouseColor.black.withAlpha(135),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "${index + 1}/${widget.data.length}",
                textAlign: TextAlign.center,
                style: createTextStyle(color: HouseColor.white, fontSize: 11),
              ),
            ),
          ),
        ],
      );
}
