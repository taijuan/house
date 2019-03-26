import 'package:house/importLib.dart';

showToast(BuildContext context, String msg) {
  Toast.show(
    context,
    msg,
  );
}

showToastSuccess(BuildContext context, {String msg}) {
  Toast.show(
    context,
    msg ?? "successfully",
  );
}

class Toast {
  static const int LENGTH_SHORT = 3;
  static const int LENGTH_LONG = 5;
  static const int BOTTOM = 0;
  static const int CENTER = 1;
  static const int TOP = 2;

  static void show(
    BuildContext context,
    String msg, {
    int duration = LENGTH_SHORT,
  }) {
    ToastView.dismiss();
    ToastView.createView(
      msg,
      context,
      duration,
    );
  }
}

class ToastView {
  static final ToastView _singleton = new ToastView._();

  ToastView._();

  factory ToastView() {
    return _singleton;
  }

  static OverlayState overlayState;
  static OverlayEntry overlayEntry;
  static bool _isVisible = false;

  static void createView(
    String msg,
    BuildContext context,
    int duration,
  ) async {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: AlignmentDirectional.center,
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            color: HouseColor.black,
            margin: EdgeInsets.only(),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    msg,
                    style: createTextStyle(color: HouseColor.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    _isVisible = true;
    if (overlayState != null) {
      overlayState.insert(overlayEntry);
      await Future.delayed(
        Duration(seconds: duration ?? Toast.LENGTH_SHORT),
      );
      dismiss();
    }
  }

  static dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    overlayEntry?.remove();
  }
}
