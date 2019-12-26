import 'package:house/importLib.dart';

class ChangePassword extends BaseStatefulWidget {
  @override
  _ChangePasswordState createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends BaseAppBarAndBodyState<ChangePassword> {
  TextEditingController userOldPwdController = TextEditingController();
  TextEditingController userPwd1Controller = TextEditingController();
  TextEditingController userPwd2Controller = TextEditingController();

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).changeEmail,
      ),
      menu: TitleAppBar.appBarMenu(context, onPressed: () {
        _changePassword();
      }),
    );
  }

  @override
  Widget body(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        UserPasswordTextField(
          controller: userOldPwdController,
          title: HouseValue.of(context).password,
        ),
        UserPasswordTextField(
          controller: userPwd1Controller,
          title: HouseValue.of(context).newPassword,
        ),
        UserPasswordTextField(
          controller: userPwd2Controller,
          title: HouseValue.of(context).confirmPassword,
        )
      ],
    );
  }

  void _changePassword() async {
    String oldPwd = userOldPwdController.text;
    if (oldPwd.isEmpty) {
      showMsgToast(context, HouseValue.of(context).typeYourEmailAddress);
      return;
    }
    String pwd1 = userPwd1Controller.text;
    if (pwd1.isEmpty) {
      showMsgToast(context, HouseValue.of(context).typeNewPassword);
      return;
    }
    String pwd2 = userPwd2Controller.text;
    if (pwd2.isEmpty) {
      showMsgToast(context, HouseValue.of(context).retypeYourPassword);
      return;
    }
    if (pwd1 != pwd2) {
      showMsgToast(context, HouseValue.of(context).passwordError);
      return;
    }
    showLoadingDialog(context);
    modifyUserInfo(
      context,
      oldPassword: oldPwd,
      password: pwd1,
      cancelToken: cancelToken,
    ).then((user) {
      pop(context);
      pop(context);
      Provide.value<ProviderUser>(context).save(user);
    }).catchError((e) {
      pop(context);
      showMsgToast(context, e.toString());
    });
  }
}
