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
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          alignment: AlignmentDirectional.center,
          child: Text(
            content??HouseValue.of(context).areYouSure,
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

Future showInputDialog(
  BuildContext context, {
  String hint = "input content",
  int maxLength = 30,
  int maxLines = 1,
  VoidCallback onCancelPressed,
  void Function(String content) onOkPressed,
}) {
  final TextEditingController controller = TextEditingController();
  return showContentDialog(
    context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          alignment: AlignmentDirectional.center,
          child: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: HouseColor.gray,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: HouseColor.gray,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: HouseColor.green,
                ),
              ),
            ),
            maxLength: maxLength,
            maxLines: maxLines,
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
                  controller.dispose();
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
                  String content = controller.text;
                  if (onOkPressed != null && !DataUtils.isEmpty(content)) {
                    onOkPressed(content);
                  }
                  controller.dispose();
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
