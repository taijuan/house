import 'package:house/importLib.dart';

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
            PageView.builder(
              itemBuilder: (context, index) {
                return CacheImage(
                  DataUtils.getImageUrl(widget.data[index].picUrl),
                  fit: BoxFit.contain,
                );
              },
              itemCount: widget.data.length,
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  this._index = index;
                });
              },
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
                  child: Icon(
                    HouseIcons.backIcon,
                    color: HouseColor.white,
                    size: 18,
                  ),
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
