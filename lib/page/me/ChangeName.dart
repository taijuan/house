import 'package:house/importLib.dart';

class ChangeName extends BaseStatefulWidget {
  @override
  _ChangeNameState createState() {
    return _ChangeNameState();
  }
}

class _ChangeNameState extends BaseAppBarAndBodyState<ChangeName> {
  TextEditingController _mController, _xController;
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
      menu: TitleAppBar.appBarMenu(context, onPressed: _changeName),
    );
  }

  @override
  Widget body(BuildContext context) {
    if (user == null) {
      return Container();
    }
    _mController =
        _mController ?? TextEditingController(text: user.firstName ?? "");
    _xController =
        _xController ?? TextEditingController(text: user.lastName ?? "");
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        UserNameTextField(
          title: HouseValue.of(context).firstName,
          userNameController: _mController,
          keyboardType: TextInputType.text,
        ),
        UserNameTextField(
          title: HouseValue.of(context).lastName,
          userNameController: _xController,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  void _changeName() async {
    String firstName = _mController.text;
    if (firstName.isEmpty) {
      showToast(context, HouseValue.of(context).typeFirstName);
      return;
    }
    String lastName = _xController.text;
    if (lastName.isEmpty) {
      showToast(context, HouseValue.of(context).typeLastName);
      return;
    }
    showLoadingDialog(context);
    modifyUserInfo(
      context,
      firstName: firstName,
      lastName: lastName,
      cancelToken: cancelToken,
    ).then((user) {
      user.saveUser();
      pop(context);
      pop(context);
    }).catchError((e) {
      pop(context);
      showToast(context, e.toString());
    });
  }
}
