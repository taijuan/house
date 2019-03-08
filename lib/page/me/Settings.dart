import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';

class Settings extends BaseStatefulWidget {
  @override
  _SettingsState createState() {
    return _SettingsState();
  }
}

class _SettingsState extends BaseAppBarAndBodyState<Settings> {
  bool isNotificationPush = false;
  String cacheSize = "0.0kb";

  @override
  void initState() {
    backgroundColor = HouseColor.lightGray;
    _refreshCacheSize();
    super.initState();
  }

  void _refreshCacheSize() {
    CleanCacheUtils.formatCacheFileSize().then((value) {
      this.cacheSize = value;
      setState(() {});
    });
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(HouseValue.of(context).settings),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      decoration: BoxDecoration(color: HouseColor.white),
    );
  }

  @override
  Widget body(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        ///
        SizedBox(
          height: 8,
          width: MediaQuery.of(context).size.width,
        ),

        ///推送开关
        Container(
          height: 42,
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width,
          color: HouseColor.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  HouseValue.of(context).notificationPush,
                  style: createTextStyle(),
                ),
              ),
              CupertinoSwitch(
                value: isNotificationPush,
                onChanged: (bool value) {
                  isNotificationPush = value;
                  setState(() {});
                },
              )
            ],
          ),
        ),

        ///
        SizedBox(
          height: 1,
        ),

        /// 清除缓存
        FlatButton(
          onPressed: () {
            showAlertDialog(
              context,
              content: HouseValue.of(context).areYouOk.replaceAll(
                    "#",
                    HouseValue.of(context).clearCache,
                  ),
              onOkPressed: () {
                CleanCacheUtils.clearCache().whenComplete(() {
                  _refreshCacheSize();
                });
              },
            );
          },
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          color: HouseColor.white,
          child: Container(
            height: 42,
            padding: EdgeInsets.only(),
            margin: EdgeInsets.only(),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    HouseValue.of(context).clearCache,
                    style: createTextStyle(),
                  ),
                ),
                Text(
                  cacheSize,
                  style: createTextStyle(color: HouseColor.gray, fontSize: 13),
                ),
              ],
            ),
          ),
        ),

        ///
        SizedBox(
          height: 8,
        ),

        ///隐私条款
        FlatButton(
          onPressed: () {
            push(context, WebPage("https://www.baidu.com/"));
          },
          padding: EdgeInsets.symmetric(horizontal: 16),
          color: HouseColor.white,
          child: Container(
            height: 42,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    HouseValue.of(context).privacyPolicy,
                    style: createTextStyle(),
                  ),
                ),
                Transform.rotate(
                  angle: pi / 2,
                  child: Image.asset("image/house_fold.webp"),
                ),
              ],
            ),
          ),
        ),

        ///
        SizedBox(
          height: 1,
        ),

        ///关于我们
        FlatButton(
          onPressed: () {
            push(context, WebPage("https://www.baidu.com/"));
          },
          padding: EdgeInsets.symmetric(horizontal: 16),
          color: HouseColor.white,
          child: Container(
            height: 42,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    HouseValue.of(context).aboutUs,
                    style: createTextStyle(),
                  ),
                ),
                Transform.rotate(
                  angle: pi / 2,
                  child: Image.asset("image/house_fold.webp"),
                ),
              ],
            ),
          ),
        ),

        ///
        SizedBox(
          height: 8,
        ),

        ///退出登录
        Container(
          color: HouseColor.white,
          child: FlatButton(
            onPressed: () {
              showAlertDialog(
                context,
                content: HouseValue.of(context).areYouOkToExitTheApplication,
                onOkPressed: () {
                  pushLogin(context);
                },
              );
            },
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: HouseColor.white,
            child: Container(
              alignment: Alignment.center,
              height: 42,
              width: MediaQuery.of(context).size.width,
              child: Text(
                HouseValue.of(context).logOut,
                style: createTextStyle(color: HouseColor.green),
              ),
            ),
          ),
        )
      ],
    );
  }
}
