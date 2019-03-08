import 'package:house/importLib.dart';

abstract class BaseAppBarAndBodyState<T extends BaseStatefulWidget>
    extends BaseState<T> {
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    backgroundColor = backgroundColor ?? Theme.of(context).backgroundColor;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: appBar(context) ?? SizedBox.shrink(),
          ),
          Expanded(child: body(context)),
          SizedBox(
            width: double.infinity,
            child: bottomNavigationBar(context) ?? SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  Widget appBar(BuildContext context);

  Widget body(BuildContext context);

  Widget bottomNavigationBar(BuildContext context) => SizedBox.shrink();
}
