import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:house/base/BaseStatefulWidget.dart';
import 'package:house/importLib.dart';

class Login extends BaseStatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends BaseAppBarAndBodyState<Login> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPwdController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  VoidCallback _listener;

  @override
  void initState() {
    if (_listener == null) {
      _listener = () {
        setState(() {});
      };
      _userNameController.addListener(_listener);
      _userPwdController.addListener(_listener);
    }
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.removeListener(_listener);
    _userNameController.dispose();
    _userPwdController.removeListener(_listener);
    _userPwdController.dispose();
    super.dispose();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return SignInAppBar(
      context,
      showBack: false,
    );
  }

  @override
  Widget body(BuildContext context) {
    return buildListView(context);
  }

  ListView buildListView(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        ///输入Email,
        UserNameTextField(
          title: HouseValue.of(context).email,
          userNameController: _userNameController,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          top: 16,
        ),

        ///密码输入
        UserPasswordTextField(
          controller: _userPwdController,
          title: HouseValue.of(context).password,
          focusNode: _focusNode,
        ),

        ///登录按钮
        UserButton(
          _checkLoginBtStatus()
              ? () {
                  _login(context);
                }
              : null,
          HouseValue.of(context).signIn,
        ),

        ///忘记密码

        Container(
          height: 16,
        ),
        RawMaterialButton(
          onPressed: () {
            push(context, ForgerPassword());
          },
          fillColor: HouseColor.transparent,
          elevation: 0,
          highlightElevation: 0,
          disabledElevation: 0,
          constraints: BoxConstraints(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(
            HouseValue.of(context).forgetPassword,
            style: createTextStyle(color: HouseColor.green, fontSize: 13),
          ),
          padding: EdgeInsets.only(bottom: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),

        Container(
          height: 8,
        ),
        RawMaterialButton(
          onPressed: () {
            push(context, CheckInviteCode());
          },
          fillColor: HouseColor.transparent,
          elevation: 0,
          highlightElevation: 0,
          disabledElevation: 0,
          constraints: BoxConstraints(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(
            HouseValue.of(context).signUpFromCode,
            style: createTextStyle(color: HouseColor.green, fontSize: 13),
          ),
          padding: EdgeInsets.only(bottom: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),

        Container(
          height: 8,
        ),
        RawMaterialButton(
          onPressed: () {
            push(context, NoHaveInviteCodeSignUp());
          },
          constraints: BoxConstraints(),
          elevation: 0,
          fillColor: HouseColor.transparent,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          highlightElevation: 0,
          child: Text(
            HouseValue.of(context).signUpForVendor,
            style: createTextStyle(color: HouseColor.green, fontSize: 13),
          ),
          padding: EdgeInsets.only(bottom: 2, left: 4, right: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),

        Container(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                setState(() {
                  _userNameController.text = "agency@qq.com";
                  _userPwdController.text = "123456";
                });
              },
              padding: EdgeInsets.symmetric(horizontal: 8),
              textColor: HouseColor.white,
              child: Text(TypeStatus.agent.descEn),
              color: HouseColor.green,
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _userNameController.text = "landlord@qq.com";
                  _userPwdController.text = "123456";
                });
              },
              padding: EdgeInsets.symmetric(horizontal: 8),
              textColor: HouseColor.white,
              child: Text(TypeStatus.landlord.descEn),
              color: HouseColor.green,
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _userNameController.text = "lessee@qq.com";
                  _userPwdController.text = "123456";
                });
              },
              padding: EdgeInsets.symmetric(horizontal: 8),
              textColor: HouseColor.white,
              child: Text(TypeStatus.tenant.descEn),
              color: HouseColor.green,
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _userNameController.text = "vendor@qq.com";
                  _userPwdController.text = "123456";
                });
              },
              padding: EdgeInsets.symmetric(horizontal: 8),
              textColor: HouseColor.white,
              child: Text(TypeStatus.vendor.descEn),
              color: HouseColor.green,
            ),
          ],
        )
      ],
    );
  }

  bool _checkLoginBtStatus() {
    String account = _userNameController.text;
    String password = _userPwdController.text;
    return account.isNotEmpty && password.isNotEmpty;
  }

  _login(BuildContext context) {
    String account = _userNameController.text;
    String password = _userPwdController.text;
    if (account.isEmpty) {
      showToast(context, HouseValue.of(context).typeYourEmailAddress);
      return;
    }
    if (!DataUtils.checkEmail(account)) {
      showToast(context, HouseValue.of(context).isNotEmail);
      return;
    }
    if (password.isEmpty) {
      showToast(context, HouseValue.of(context).typeYourPassword);
      return;
    }
    if (password.length < 6) {
      showToast(context, HouseValue.of(context).passwordLengthMoreThan6);
      return;
    }
    showLoadingDialog(context);
    login(
      context,
      account,
      password,
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
        LogUtils.log(e);
        pop(context);
        showToast(context, e.toString());
      });
  }
}
