import 'package:house/importLib.dart';

class ChangeEmail extends BaseStatefulWidget {
  @override
  _ChangeEmailState createState() {
    return _ChangeEmailState();
  }
}

class _ChangeEmailState extends BaseAppBarAndBodyState<ChangeEmail> {
  final TextEditingController _userNameController = TextEditingController(),
      _userCodeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String code;

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).changeEmail,
      ),
      menu: TitleAppBar.appBarMenu(context, onPressed: () {
        _changeEmail();
      }),
    );
  }

  @override
  Widget body(BuildContext context) {
    _userNameController.addListener(() {
      setState(() {});
    });
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        UserNameTextField(
          title: HouseValue.of(context).email,
          userNameController: _userNameController,
          top: 16,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
        ),
        UserCodeTextField(
          _userCodeController,
          _userNameController.text.isNotEmpty ? _sendEmail : null,
          focusNode: _focusNode,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userCodeController.dispose();
    super.dispose();
  }

  void _changeEmail() async {
    String email = _userNameController.text;
    if (email.isEmpty) {
      showToast(context, HouseValue.of(context).typeYourEmailAddress);
      return;
    }
    String code = _userCodeController.text;
    if (code.isEmpty) {
      showToast(context, HouseValue.of(context).typeVerificationCode);
      return;
    }
    if (this.code != code) {
      showToast(context, HouseValue.of(context).codeError);
      return;
    }
    showLoadingDialog(context);
    modifyUserInfo(
      context,
      email: email,
      cancelToken: cancelToken,
    ).then((user) {
      pop(context);
      pop(context);
      Provide.value<ProviderUser>(context).save(user);
    }).catchError((e) {
      pop(context);
      showToast(context, e.toString());
    });
  }

  void _sendEmail() {
    String account = _userNameController.text;
    if (account.isEmpty) {
      showToast(context, HouseValue.of(context).typeYourEmailAddress);
      return;
    }
    showLoadingDialog(context);
    sendEmail(
      context,
      account,
      cancelToken: cancelToken,
    )
      ..then((value) {
        code = value;
        pop(context);
      })
      ..catchError((e) {
        pop(context);
        showToast(context, e.toString());
      });
  }
}
