import 'dart:io';

import 'package:house/importLib.dart';

class MeAppBar extends BaseAppBar {
  final BuildContext context;

  MeAppBar(this.context);

  @override
  _MeAppBarState createState() {
    return _MeAppBarState();
  }

  @override
  Size get preferredSize => Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.width * 244 / 360,
      );
}

class _MeAppBarState extends BaseState<MeAppBar> {
  User user = User.getUserSync();

  void _refresh() {
    User.getUser().then((user) {
      setState(() {
        this.user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 244 / 360,
      color: HouseColor.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TitleAppBar(
              context: context,
              foregroundDecoration: BoxDecoration(),
              title: TitleAppBar.appBarTitle(
                user.type.descEn,
                style: createTextStyle(
                  color: HouseColor.white,
                  fontSize: 17,
                  fontFamily: fontFamilySemiBold,
                ),
              ),
            ),
          ),
          Spacer(),
          OutlineButton(
            onPressed: _pickImage,
            shape: CircleBorder(),
            borderSide: BorderSide(
              color: HouseColor.white,
              width: 3,
              style: BorderStyle.solid,
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: HouseCacheNetworkImage(
              DataUtils.getImageUrl(user.headImage),
              width: 88,
              height: 88,
            ),
          ),
          Spacer(),
          Container(
            height: 48,
            alignment: AlignmentDirectional.center,
            child: Text(
              user.getUserName(),
              textAlign: TextAlign.center,
              style: createTextStyle(
                color: HouseColor.white,
                fontSize: 17,
                fontFamily: fontFamilySemiBold,
              ),
            ),
          ),
          Spacer(),
          Container(height: 4),
        ],
      ),
    );
  }

  void _pickImage() {
    ImagePicker.pickImage(
      source: ImageSource.gallery,
    ).then((file) {
      LogUtils.log(file.path);
      if (file != null) {
        _changeHeadImage(file);
      }
    });
  }

  void _changeHeadImage(File file) async {
    showLoadingDialog(context);
    await modifyUserInfo(
      context,
      imgStr: file,
      cancelToken: cancelToken,
    ).then((user) {
      pop(context);
      user.saveUser();
      _refresh();
    });
  }
}
