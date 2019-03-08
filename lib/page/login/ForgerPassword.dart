import 'package:house/importLib.dart';

class ForgerPassword extends BaseStatefulWidget {
  @override
  _ForgerPasswordState createState() {
    return _ForgerPasswordState();
  }
}

class _ForgerPasswordState extends BaseAppBarAndBodyState<ForgerPassword> {
  TextEditingController _userNameController = TextEditingController();
  VoidCallback _listener;

  @override
  void initState() {
    if (_listener == null) {
      _listener = () {
        setState(() {});
      };
      _userNameController.addListener(_listener);
    }
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.removeListener(_listener);
    _userNameController.dispose();
    super.dispose();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return SignInAppBar(context);
  }

  @override
  Widget body(BuildContext context) {
    return buildListView(context);
  }

  ListView buildListView(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        ///发送email验证码header
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: HouseColor.lightGreen,
          alignment: Alignment.centerLeft,
          child: Text(
            HouseValue.of(context).sendEmailNotice,
            style: createTextStyle(color: HouseColor.green, fontSize: 13),
          ),
        ),

        ///email输入框
        UserNameTextField(
          title: HouseValue.of(context).email,
          userNameController: _userNameController,
          top: 16,
        ),

        ///email点击发送按钮
        UserButton(
          _checkEmailBtStatus() ? _retrievePassword : null,
          HouseValue.of(context).send,
        ),
      ],
    );
  }

  bool _checkEmailBtStatus() {
    String account = _userNameController.text;
    return account.isNotEmpty;
  }

  _retrievePassword() {
    String account = _userNameController.text;
    if (account.isEmpty) {
      showToast(context, HouseValue.of(context).typeYourEmailAddress);
      return;
    }
    if (!DataUtils.checkEmail(account)) {
      showToast(context, HouseValue.of(context).isNotEmail);
      return;
    }
    showLoadingDialog(context);
    retrievePassword(
      context,
      account,
      cancelToken: cancelToken,
    )
      ..then((v) {
        pop(context);
        pushReplacement(context, ReceiveCode(_userNameController.text));
      })
      ..catchError((e) {
        pop(context);
        showToast(context, e.toString());
      });
  }
}
