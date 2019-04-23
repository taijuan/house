import 'package:house/importLib.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends BaseStatefulWidget {
  final String url, title;

  WebPage(
    this.url, {
    this.title,
  });

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends BaseAppBarAndBodyState<WebPage> {
  @override
  BaseAppBar appBar(BuildContext context) => TitleAppBar(
        context: context,
        title: TitleAppBar.appBarTitle(widget.title),
        navigatorBack: TitleAppBar.navigatorBackBlack(context),
      );

  @override
  Widget body(BuildContext context) {
    return WebView(
      onWebViewCreated: (WebViewController webViewController) {},
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
