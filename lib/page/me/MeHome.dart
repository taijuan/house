import 'package:house/importLib.dart';
import 'package:house/page/me/NotificationPage.dart';

class MeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MeAppBar(context),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        const SizedBox(height: 24),

        /// 个人信息
        _buildIconNameHot(
          onPressed: () {
            push(context, ProfileHome());
          },
          icon: HouseIcons.profileIcon,
          name: HouseValue.of(context).profile,
        ),

        ///证书
        User.getUserSync().type.value == TypeStatus.vendor.value
            ? _buildIconNameHot(
                onPressed: () {
                  push(context, CertificateListPage());
                },
                icon: HouseIcons.certificationIcon,
                name: HouseValue.of(context).certificate,
              )
            : SizedBox.shrink(),

        /// 设置
        _buildIconNameHot(
          onPressed: () {
            push(context, Settings());
          },
          icon: HouseIcons.settingsIcon,
          name: HouseValue.of(context).settings,
        ),

        ///通知列表
        _buildIconNameHot(
          onPressed: () {
            push(context, NotificationPage());
          },
          icon: HouseIcons.notificationIcon,
          name: HouseValue.of(context).notifications,
          hotNum: 100,
        ),
      ],
    );
  }

  FlatButton _buildIconNameHot({
    VoidCallback onPressed,
    @required IconData icon,
    @required String name,
    int hotNum = 0,
  }) {
    hotNum = hotNum > 99 ? 99 : hotNum;
    return FlatButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(),
      child: Container(
        width: 160,
        height: 48,
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: HouseColor.gray,
            ),
            SizedBox(
              width: 12,
            ),
            Padding(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: createTextStyle(
                  fontSize: 17,
                  height: 1.0,
                ),
              ),
              padding: EdgeInsets.only(bottom: 2),
            ),
            SizedBox(
              width: 8,
            ),
            hotNum == 0
                ? SizedBox.shrink()
                : Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: HouseColor.red,
                    ),
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      hotNum.toString(),
                      textAlign: TextAlign.center,
                      style: createTextStyle(
                        color: HouseColor.white,
                        fontSize: 11,
                        fontFamily: fontFamilyRegular,
                        height: 1.0,
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: 1),
                  ),
          ],
        ),
      ),
    );
  }
}
