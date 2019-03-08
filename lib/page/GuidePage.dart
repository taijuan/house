import 'package:house/importLib.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuidePage extends BaseStatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends BaseAppBarAndBodyState<GuidePage> {
  @override
  void initState() {
    SharedPreferences.getInstance().then((sp) {
      PackageInfo.fromPlatform().then((info) {
        if (info != null) {
          sp.setString("versionCode", info.buildNumber);
        }
      });
    });
    super.initState();
  }

  @override
  Widget appBar(BuildContext context) => SizedBox.shrink();

  @override
  Widget body(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          TabBarView(
            children: [
              SizedBox.expand(
                child: Image.asset(
                  "image/house_loading_image_placeholder.webp",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox.expand(
                child: Image.asset(
                  "image/house_loading_image_placeholder.webp",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox.expand(
                child: Image.asset(
                  "image/house_loading_image_placeholder.webp",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox.expand(
                child: Image.asset(
                  "image/house_loading_image_placeholder.webp",
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          Positioned(
            bottom: 36,
            child: TabPageSelector(
              color: HouseColor.white,
              selectedColor: HouseColor.green,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            right: 12,
            child: FlatButton(
              onPressed: () {
                loginSuccessToNavigator(context);
              },
              color: HouseColor.white,
              child: Text(
                HouseValue.of(context).skip,
                style: createTextStyle(color: HouseColor.green),
              ),
            ),
          )
        ],
      ),
    );
  }
}
