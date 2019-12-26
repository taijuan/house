import 'package:house/importLib.dart';

class HaveInviteCodeSignUp extends BaseStatefulWidget {
  final String id;
  final String email;
  final int type;
  final String firstName, lastName;

  HaveInviteCodeSignUp(
    this.id,
    this.email,
    this.type,
    this.firstName,
    this.lastName,
  );

  @override
  _HaveInviteCodeSignUpState createState() {
    return _HaveInviteCodeSignUpState();
  }
}

class _HaveInviteCodeSignUpState
    extends BaseAppBarAndBodyState<HaveInviteCodeSignUp> {
  TextEditingController _userNameController = TextEditingController(),
      _userPwd1Controller = TextEditingController(),
      _userPwd2Controller = TextEditingController(),
      _firstNameController = TextEditingController(),
      _lastNameController = TextEditingController();

  final FocusNode _userPwd1FocusNode = FocusNode(),
      _userPwd2FocusNode = FocusNode(),
      _firstNameFocusNode = FocusNode(),
      _lastNameFocusNode = FocusNode();
  VoidCallback _listener;

  @override
  void initState() {
    if (_listener == null) {
      _listener = () {
        setState(() {});
      };
      _userNameController.addListener(_listener);
      _userPwd1Controller.addListener(_listener);
      _userPwd2Controller.addListener(_listener);
      _firstNameController.addListener(_listener);
      _lastNameController.addListener(_listener);
    }
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.removeListener(_listener);
    _userPwd1Controller.removeListener(_listener);
    _userPwd2Controller.removeListener(_listener);
    _firstNameController.removeListener(_listener);
    _lastNameController.removeListener(_listener);
    _userNameController.dispose();
    _userPwd1Controller.dispose();
    _userPwd2Controller.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(HouseValue.of(context).signUpFromCode),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    _userNameController = TextEditingController(text: widget.email);
    return buildListView(context);
  }

  ListView buildListView(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        ///输入Email
        UserNameTextField(
          title: HouseValue.of(context).email,
          userNameController: _userNameController,
          enabled: false,
          top: 16,
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
            FocusScope.of(context).requestFocus(_userPwd1FocusNode);
          },
        ),

        ///密码输入
        UserPasswordTextField(
          controller: _userPwd1Controller,
          title: HouseValue.of(context).password,
          textInputAction: TextInputAction.next,
          focusNode: _userPwd1FocusNode,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_userPwd2FocusNode);
          },
        ),

        ///输入确认密码
        UserPasswordTextField(
          controller: _userPwd2Controller,
          title: HouseValue.of(context).confirmPassword,
          focusNode: _userPwd2FocusNode,
        ),

        ///登录按钮
        UserButton(
          _checkData() ? _register : null,
          HouseValue.of(context).signUpForVendor,
        ),

        UserServiceNotice(),
      ],
    );
  }

  bool _checkData() {
    String account = _userNameController.text;
    String password1 = _userPwd1Controller.text;
    String password2 = _userPwd2Controller.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    return account.isNotEmpty &&
        password1.isNotEmpty &&
        password2.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty;
  }

  _register() {
    String account = _userNameController.text;
    String password1 = _userPwd1Controller.text;
    String password2 = _userPwd2Controller.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
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
    showLoadingDialog(context);
    register(
      context,
      id: widget.id,
      account: widget.email,
      password: password1,
      firstName: firstName,
      lastName: lastName,
      type: widget.type,
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
}
