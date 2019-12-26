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
      _userCodeController = TextEditingController(),
      _firstNameController = TextEditingController(),
      _lastNameController = TextEditingController(),
      _companyNameController = TextEditingController();

  final FocusNode _userPwd1FocusNode = FocusNode(),
      _userPwd2FocusNode = FocusNode(),
      _userCodeFocusNode = FocusNode(),
      _firstNameFocusNode = FocusNode(),
      _lastNameFocusNode = FocusNode(),
      _companyNameFocusNode = FocusNode();
  VoidCallback _listener;
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
      _firstNameController.addListener(_listener);
      _lastNameController.addListener(_listener);
      _companyNameController.addListener(_listener);
    }
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.removeListener(_listener);
    _userPwd1Controller.removeListener(_listener);
    _userPwd2Controller.removeListener(_listener);
    _userCodeController.removeListener(_listener);
    _firstNameController.removeListener(_listener);
    _lastNameController.removeListener(_listener);
    _companyNameController.removeListener(_listener);
    _userNameController.dispose();
    _userPwd1Controller.dispose();
    _userPwd2Controller.dispose();
    _userCodeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
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
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        ///输入Email
        UserNameTextField(
          title: HouseValue.of(context).email,
          userNameController: _userNameController,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_firstNameFocusNode);
          },
        ),

        ///输入FirstName
        UserNameTextField(
          focusNode: _firstNameFocusNode,
          title: HouseValue.of(context).firstName,
          userNameController: _firstNameController,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_lastNameFocusNode);
          },
        ),

        ///输入LastName
        UserNameTextField(
          focusNode: _lastNameFocusNode,
          title: HouseValue.of(context).lastName,
          userNameController: _lastNameController,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_companyNameFocusNode);
          },
        ),

        ///输入CompanyName
        UserNameTextField(
          focusNode: _companyNameFocusNode,
          title: HouseValue.of(context).companyName,
          userNameController: _companyNameController,
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
          HouseValue.of(context).signUpForVendor,
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
      showMsgToast(context, HouseValue.of(context).typeYourEmailAddress);
      return;
    }
    if (account.isEmpty) {
      showMsgToast(context, HouseValue.of(context).isNotEmail);
      return;
    }
    if (password1.isEmpty) {
      showMsgToast(context, HouseValue.of(context).typeYourPassword);
      return;
    }
    if (password2.isEmpty) {
      showMsgToast(context, HouseValue.of(context).retypeYourPassword);
      return;
    }
    if (password1.length < 6 || password2.length < 6) {
      showMsgToast(context, HouseValue.of(context).passwordLengthMoreThan6);
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
        showMsgToast(context, HouseValue.of(context).success);
      })
      ..catchError((e) {
        pop(context);
        showMsgToast(context, e.toString());
      });
  }

  void _register() {
    String account = _userNameController.text;
    String password1 = _userPwd1Controller.text;
    String password2 = _userPwd2Controller.text;
    String code = _userCodeController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String companyName = _companyNameController.text;
    if (account.isEmpty) {
      showMsgToast(context, HouseValue.of(context).typeYourEmailAddress);
      return;
    }
    if (password1.isEmpty) {
      showMsgToast(context, HouseValue.of(context).typeYourPassword);
      return;
    }
    if (password2.isEmpty) {
      showMsgToast(context, HouseValue.of(context).retypeYourPassword);
      return;
    }
    if (password1 != password2) {
      showMsgToast(context, HouseValue.of(context).passwordError);
      return;
    }
    if (code.isEmpty) {
      showMsgToast(context, HouseValue.of(context).typeVerificationCode);
      return;
    }
    if (emailCode != _userCodeController.text) {
      showMsgToast(context, HouseValue.of(context).codeError);
      return;
    }
    showLoadingDialog(context);
    register(
      context,
      account: account,
      password: password1,
      firstName: firstName,
      lastName: lastName,
      type: 4,
      companyName: companyName,
      cancelToken: cancelToken,
    )
      ..then((user) {
        Provide.value<ProviderUser>(context).save(
          user,
          onSaveWhenComplete: () {
            loginSuccessToNavigator(context);
          },
        );
      })
      ..catchError((e) {
        pop(context);
        showMsgToast(context, e.toString());
      });
  }

  bool _checkData({bool checkCode: true}) {
    String account = _userNameController.text;
    String password1 = _userPwd1Controller.text;
    String password2 = _userPwd2Controller.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String companyName = _companyNameController.text;
    if (checkCode) {
      return account.isNotEmpty &&
          password1.isNotEmpty &&
          password2.isNotEmpty &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          companyName.isNotEmpty;
    } else {
      String code = _userCodeController.text;
      return account.isNotEmpty &&
          password1.isNotEmpty &&
          password2.isNotEmpty &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          companyName.isNotEmpty &&
          code.isNotEmpty;
    }
  }
}
