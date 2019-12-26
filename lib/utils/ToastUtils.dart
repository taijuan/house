import 'package:house/importLib.dart';
import 'package:oktoast/oktoast.dart';

showMsgToast(BuildContext context, String msg) {
  Widget widget = Container(
    margin: EdgeInsets.symmetric(horizontal: 48),
    decoration: BoxDecoration(
      color: HouseColor.halfTransparent,
      borderRadius: BorderRadius.circular(4),
    ),
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    child: Text(
      msg,
      style: createTextStyle(color: HouseColor.white, fontSize: 18),
      textAlign: TextAlign.center,
    ),
  );
  showToastWidget(
    SizedBox(
      width: double.infinity,
      child: widget,
    ),
    position: ToastPosition(
      align: Alignment.bottomCenter,
      offset: -90.0,
    ),
  );
}

showToastSuccess(BuildContext context, {String msg}) {
  showMsgToast(context, msg ?? "successfully");
}
