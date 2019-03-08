import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';

Future showLoadingDialog(BuildContext context) {
  return showContentDialog(
    context,
    barrierDismissible: false,
    child: WillPopScope(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: HouseColor.white,
          borderRadius: BorderRadius.circular(4),
        ),
        width: 80,
        height: 80,
        child: Text(
          "加载中...",
          style: createTextStyle(),
        ),
      ),
      onWillPop: () => Future.value(false),
    ),
  );
}

Future showAlertDialog(
  BuildContext context, {
  String content,
  VoidCallback onCancelPressed,
  VoidCallback onOkPressed,
}) {
  return showContentDialog(
    context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(24),
          alignment: AlignmentDirectional.center,
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: createTextStyle(),
          ),
        ),
        Container(
          color: HouseColor.divider,
          height: 0.5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: RawMaterialButton(
                shape: RoundedRectangleBorder(),
                constraints: BoxConstraints(minHeight: 48),
                onPressed: () {
                  pop(context);
                  if (onCancelPressed != null) {
                    onCancelPressed();
                  }
                },
                child: Text(
                  HouseValue.of(context).cancel,
                  style: createTextStyle(color: HouseColor.gray),
                ),
              ),
            ),
            Container(
              color: HouseColor.divider,
              width: 0.5,
              height: 48,
            ),
            Expanded(
              child: RawMaterialButton(
                shape: RoundedRectangleBorder(),
                constraints: BoxConstraints(minHeight: 48),
                onPressed: () {
                  pop(context);
                  if (onOkPressed != null) {
                    onOkPressed();
                  }
                },
                child: Text(
                  HouseValue.of(context).ok,
                  style: createTextStyle(color: HouseColor.green),
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
}

Future showContentDialog(
  BuildContext context, {
  bool barrierDismissible: true,
  AlignmentGeometry alignment: AlignmentDirectional.center,
  EdgeInsetsGeometry margin,
  Widget child,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return Container(
        alignment: alignment,
        child: Card(
          margin: margin ?? EdgeInsets.symmetric(horizontal: 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0.0,
          child: child,
        ),
      );
    },
  );
}
