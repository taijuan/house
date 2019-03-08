import 'package:house/importLib.dart';

class ImagePageView extends BaseStatefulWidget {
  final double width, height;
  final List<String> data;
  final VoidCallback onPressed;

  ImagePageView(this.data, this.width, this.height, {this.onPressed});

  @override
  _ImagePageViewState createState() => _ImagePageViewState();
}

class _ImagePageViewState extends BaseState<ImagePageView> {
  int index = 0;
  PageController _controller;

  @override
  void initState() {
    if (_controller == null) {
      _controller = PageController(initialPage: index)
        ..addListener(() {
          index = _controller.page.round();
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _controller,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: widget.onPressed,
                  child: HouseCacheNetworkImage(
                    DataUtils.getImageUrl(widget.data[index]),
                    width: widget.width,
                    height: widget.height,
                  ),
                );
              },
              itemCount: widget.data.length,
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
        ),
      );
}
