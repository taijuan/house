import 'package:flutter/gestures.dart';
import 'package:house/importLib.dart';

class UserServiceNotice extends BaseStatefulWidget {
  @override
  _UserServiceNoticeState createState() {
    return _UserServiceNoticeState();
  }
}

class _UserServiceNoticeState extends BaseState<UserServiceNotice> {
  TapGestureRecognizer privacyPolicyTap = TapGestureRecognizer();
  TapGestureRecognizer conditionsOfUseTap = TapGestureRecognizer();

  @override
  Widget build(BuildContext context) {
    privacyPolicyTap.onTap = () {
      push(context, WebPage("https://www.baidu.com/"));
    };
    conditionsOfUseTap.onTap = () {
      push(context, WebPage("https://www.baidu.com/"));
    };
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 36),
      child: Text.rich(
        TextSpan(
          style: createTextStyle(fontSize: 13),
          text: HouseValue.of(context).bySigningUpIAgreeToThe,
          children: [
            TextSpan(
              style: createTextStyle(color: HouseColor.green, fontSize: 13),
              text: HouseValue.of(context).privacyPolicy,
              recognizer: privacyPolicyTap,
            ),
            TextSpan(
              style: createTextStyle(fontSize: 13),
              text: HouseValue.of(context).and,
            ),
            TextSpan(
              style: createTextStyle(color: HouseColor.green, fontSize: 13),
              text: HouseValue.of(context).conditionsOfUse,
              recognizer: conditionsOfUseTap,
            ),
          ],
        ),
      ),
    );
  }
}
