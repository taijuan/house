import 'package:cached_network_image/cached_network_image.dart';
import 'package:house/importLib.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ShowImage extends BaseStatefulWidget {
  final List<ImageData> data;
  final int startPos;

  ShowImage(this.data, {this.startPos: 0});

  @override
  _ShowImageState createState() {
    return _ShowImageState();
  }
}

class _ShowImageState extends BaseState<ShowImage> {
  PageController _controller;
  int _index = -1;

  @override
  void initState() {
    if (_index == -1) {
      _index = widget.startPos;
    }
    if (_controller == null) {
      _controller = PageController(initialPage: widget.startPos);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HouseColor.black,
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            PhotoViewGallery(
              pageOptions: widget.data.map((image) {
                String imageUrl = DataUtils.getImageUrl(image.picUrl);
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(imageUrl),
                  maxScale: 4.0,
                );
              }).toList(),
              onPageChanged: (index) {
                this._index = index;
                setState(() {});
              },
              pageController: _controller,
            ),
            Positioned(
              left: 0,
              top: MediaQuery.of(context).padding.top,
              height: 48,
              width: 48,
              child: FlatButton(
                onPressed: () {
                  pop(context);
                },
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: Image.asset("image/house_back_white.webp"),
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "${_index + 1}/${widget.data.length}",
                  style: createTextStyle(color: HouseColor.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
