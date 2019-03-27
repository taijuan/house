import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:house/importLib.dart';

class CheckInviteCode extends BaseStatefulWidget {
  @override
  _CheckInviteCodeState createState() {
    return _CheckInviteCodeState();
  }
}

class _CheckInviteCodeState extends BaseAppBarAndBodyState<CheckInviteCode> {
  TextEditingController userCodeController = TextEditingController();

  @override
  void dispose() {
    userCodeController.dispose();
    super.dispose();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(HouseValue.of(context).signUpForVendor),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    userCodeController.addListener(() {
      setState(() {});
    });
    return ListView(
      padding: EdgeInsets.only(left: 36, right: 36, top: 54),
      children: <Widget>[
        Text(
          HouseValue.of(context).pleaseEnterYourRegistrationCode,
          style: createTextStyle(),
        ),
        UserCheckInviteCodeTextField(userCodeController),
        UserButton(
          userCodeController.text.length == 6
              ? () {
                  _checkPollCode(context);
                }
              : null,
          HouseValue.of(context).next,
          left: 0,
          top: 54,
          right: 0,
        ),
      ],
    );
  }

  void _checkPollCode(context) {
    showLoadingDialog(context);
    String pollCode = userCodeController.text;
    checkPollCode(
      context,
      pollCode,
      cancelToken: cancelToken,
    )
      ..then((user) {
        pop(context);
        pushReplacement(
          context,
          HaveInviteCodeSignUp(
            user.id,
            user.email,
            user.type.value,
            user.firstName,
            user.lastName,
          ),
        );
      })
      ..catchError((e) {
        pop(context);
        showToast(context, e.toString());
      });
  }
}
