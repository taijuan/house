import 'package:house/importLib.dart';

abstract class BaseAppBarAndBodyState<T extends BaseStatefulWidget>
    extends BaseState<T> with AutomaticKeepAliveClientMixin<T> {
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    backgroundColor = backgroundColor ?? Theme.of(context).backgroundColor;
    super.build(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(context),
      body: body(context),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }

  BaseAppBar appBar(BuildContext context);

  Widget body(BuildContext context);

  Widget bottomNavigationBar(BuildContext context) => SizedBox.shrink();

  @override
  bool get wantKeepAlive => false;
}
