import 'package:house/importLib.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends BaseStatefulWidget {
  final String url;

  WebPage(this.url);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends BaseState<WebPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: 48,
            height: 48,
            child: FlatButton(
              onPressed: () {
                pop(context);
              },
              child: Icon(
                HouseIcons.backIcon,
                color: HouseColor.black,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}
