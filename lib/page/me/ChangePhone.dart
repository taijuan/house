import 'package:house/importLib.dart';

class ChangePhone extends BaseStatefulWidget {
  @override
  _ChangePhoneState createState() {
    return _ChangePhoneState();
  }
}

class _ChangePhoneState extends BaseAppBarAndBodyState<ChangePhone> {
  TextEditingController controller;
  User user;

  @override
  void initState() {
    User.getUser().then((user) {
      this.user = user;
      setState(() {});
    });
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).name,
      ),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      menu: TitleAppBar.appBarMenu(context, onPressed: _changePhone),
    );
  }

  @override
  Widget body(BuildContext context) {
    if (user == null) {
      return Container(width: 0, height: 0);
    }
    controller = controller ?? TextEditingController(text: user.tel ?? "");
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        UserNameTextField(
          title: HouseValue.of(context).phone,
          userNameController: controller,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  void _changePhone() async {
    String tel = controller.text;
    if (tel.isEmpty) {
      showMsgToast(context, HouseValue.of(context).typeFirstName);
      return;
    }
    showLoadingDialog(context);
    modifyUserInfo(
      context,
      tel: tel,
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
