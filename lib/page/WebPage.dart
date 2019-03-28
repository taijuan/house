import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:house/importLib.dart';

class WebPage extends BaseStatefulWidget {
  final String url;

  WebPage(this.url);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends BaseState<WebPage> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: TitleAppBar(
        context: context,
        title: TitleAppBar.appBarTitle("About us"),
        navigatorBack: TitleAppBar.navigatorBackBlack(
          context,
          onPressed: () {
            pop(context);
          },
        ),
      ),
      url: widget.url,
    );
  }
}
