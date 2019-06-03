import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:house/importLib.dart';

class WebPage extends StatelessWidget {
  final String url, title;

  WebPage(
    this.url, {
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      appBar: TitleAppBar(
        context: context,
        title: TitleAppBar.appBarTitle(title),
        navigatorBack: TitleAppBar.navigatorBackBlack(context),
      ),
    );
  }
}
