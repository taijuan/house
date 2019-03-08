import 'package:house/importLib.dart';

class NoHaveInviteCodeSignUp extends BaseStatefulWidget {
  @override
  _NoHaveInviteCodeSignUpState createState() {
    return _NoHaveInviteCodeSignUpState();
  }
}

class _NoHaveInviteCodeSignUpState
    extends BaseAppBarAndBodyState<NoHaveInviteCodeSignUp> {
  final TextEditingController _userNameController = TextEditingController(),
      _userPwd1Controller = TextEditingController(),
      _userPwd2Controller = TextEditingController(),
      _userCodeController = TextEditingController();
  final FocusNode _userPwd1FocusNode = FocusNode(),
      _userPwd2FocusNode = FocusNode(),
      _userCodeFocusNode = FocusNode();
  VoidCallback _listener;
  int index = -1;
  String emailCode;

  @override
  void initState() {
    if (_listener == null) {
      _listener = () {
        setState(() {});
      };
      _userNameController.addListener(_listener);
      _userPwd1Controller.addListener(_listener);
      _userPwd2Controller.addListener(_listener);
      _userCodeController.addListener(_listener);
    }
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.removeListener(_listener);
    _userPwd1Controller.removeListener(_listener);
    _userPwd2Controller.removeListener(_listener);
    _userCodeController.removeListener(_listener);
    _userNameController.dispose();
    _userPwd1Controller.dispose();
    _userPwd2Controller.dispose();
    _userCodeController.dispose();
    super.dispose();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(HouseValue.of(context).signUp),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        UserIdentityTextField(
          (index) {
            this.index = index;
          },
          this.index,
        ),

        ///输入Email
        UserNameTextField(
          title: HouseValue.of(context).email,
          userNameController: _userNameController,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_userPwd1FocusNode);
          },
        ),

        ///密码输入
        UserPasswordTextField(
          controller: _userPwd1Controller,
          title: HouseValue.of(context).password,
          focusNode: _userPwd1FocusNode,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_userPwd2FocusNode);
          },
        ),

        ///输入确认密码
        UserPasswordTextField(
          controller: _userPwd2Controller,
          title: HouseValue.of(context).confirmPassword,
          focusNode: _userPwd2FocusNode,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_userCodeFocusNode);
          },
        ),

        ///输入邮箱验证码
        UserCodeTextField(
          _userCodeController,
          _checkData() ? _sendEmail : null,
          focusNode: _userCodeFocusNode,
        ),

        ///登录按钮
        UserButton(
          _checkData(checkCode: false) ? _register : null,
          HouseValue.of(context).signUp,
        ),
        UserServiceNotice()
      ],
    );
  }

  void _sendEmail() {
    String account = _userNameController.text;
    String password1 = _userPwd1Controller.text;
    String password2 = _userPwd2Controller.text;
    if (account.isEmpty) {
      showToast(context, HouseValue.of(context).typeYourEmailAddress);
      return;
    }
    if (!DataUtils.checkEmail(account)) {
      showToast(context, HouseValue.of(context).isNotEmail);
      return;
    }
    if (password1.isEmpty) {
      showToast(context, HouseValue.of(context).typeYourPassword);
      return;
    }
    if (password2.isEmpty) {
      showToast(context, HouseValue.of(context).retypeYourPassword);
      return;
    }
    if (password1.length < 6 || password2.length < 6) {
      showToast(context, HouseValue.of(context).passwordLengthMoreThan6);
      return;
    }
    showLoadingDialog(context);
    sendEmail(
      context,
      account,
      cancelToken: cancelToken,
    )
      ..then((value) {
        pop(context);
        emailCode = value;
        showToast(context, HouseValue.of(context).success);
      })
      ..catchError((e) {
        pop(context);
        showToast(context, e.toString());
      });
  }

  void _register() {
    String account = _userNameController.text;
    String password1 = _userPwd1Controller.text;
    String password2 = _userPwd2Controller.text;
    String code = _userCodeController.text;
    if (index == -1) {
      showToast(context, HouseValue.of(context).chooseYourIdentity);
      return;
    }
    if (account.isEmpty) {
      showToast(context, HouseValue.of(context).typeYourEmailAddress);
      return;
    }
    if (password1.isEmpty) {
      showToast(context, HouseValue.of(context).typeYourPassword);
      return;
    }
    if (password2.isEmpty) {
      showToast(context, HouseValue.of(context).retypeYourPassword);
      return;
    }
    if (password1 != password2) {
      showToast(context, HouseValue.of(context).passwordError);
      return;
    }
    if (code.isEmpty) {
      showToast(context, HouseValue.of(context).typeVerificationCode);
      return;
    }
    if (emailCode != _userCodeController.text) {
      showToast(context, HouseValue.of(context).codeError);
      return;
    }
    showLoadingDialog(context);
    register(
      context,
      null,
      account,
      password1,
      null,
      (index + 1).toString(),
      cancelToken: cancelToken,
    )..then((user) {
      user.saveUser();
      loginSuccessToNavigator(context);
    })..catchError((e) {
      pop(context);
      showToast(context, e.toString());
    });
  }

  bool _checkData({bool checkCode: true}) {
    String account = _userNameController.text;
    String password1 = _userPwd1Controller.text;
    String password2 = _userPwd2Controller.text;
    if (checkCode) {
      return index != -1 &&
          account.isNotEmpty &&
          password1.isNotEmpty &&
          password2.isNotEmpty;
    } else {
      String code = _userCodeController.text;
      return index != -1 &&
          account.isNotEmpty &&
          password1.isNotEmpty &&
          password2.isNotEmpty &&
          code.isNotEmpty;
    }
  }
}
