import 'package:house/importLib.dart';
import 'package:shared_preferences/shared_preferences.dart';

void pop<T extends Object>(BuildContext context, {T result}) {
  FocusScope.of(context).unfocus();
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop<T>(result);
  }
}

Future<T> push<T extends Object>(BuildContext context, Widget route) {
  FocusScope.of(context).unfocus();
  return Navigator.of(context).push<T>(
    MaterialPageRoute(
      builder: (context) => route,
    ),
  );
}

Future<T> pushReplacement<T extends Object>(
    BuildContext context, Widget route) {
  FocusScope.of(context).unfocus();
  return Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => route,
    ),
  );
}

Future<T> pushLogin<T extends Object>(
  BuildContext context, {
  String name: "/",
}) {
  FocusScope.of(context).unfocus();
  return pushAndRemoveUntil(context, Login(), name: name);
}

void loginSuccessToNavigator(
  BuildContext context, {
  bool isFromWelCome: false,
}) async {
  FocusScope.of(context).unfocus();
  if (isFromWelCome) {
    String oldVersionCode =
        (await SharedPreferences.getInstance()).getString("versionCode") ?? "";
    String versionCode = (await PackageInfo.fromPlatform()).buildNumber ?? "";
    if (versionCode.compareTo(oldVersionCode) > 0) {
      pushReplacement(context, GuidePage());
    } else {
      pushReplacement(context, route(context));
    }
  } else {
    pushAndRemoveUntil(context, route(context));
  }
}

Widget route(BuildContext context) {
  int _lastBackTime = 0;
  return WillPopScope(
      child: home(context),
      onWillPop: () async {
        int time = DateTime.now().millisecondsSinceEpoch;
        if (time - _lastBackTime > 3000) {
          _lastBackTime = time;
          showMsgToast(context, "Click exit again !");
          return false;
        } else {
          return true;
        }
      });
}

Widget home(BuildContext context) {
  switch (Provide.value<ProviderUser>(context).typeValue) {
    case 1:
      return AgencyHome();
    case 2:
      return LandlordHome();
    case 3:
      return TenantHome();
    case 4:
      return VendorHome();
    default:
      return Login();
  }
}

Future<T> pushAndRemoveUntil<T extends Object>(
  BuildContext context,
  Widget route, {
  String name: "/",
}) {
  FocusScope.of(context).unfocus();
  return Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => route,
    ),
    ModalRoute.withName(name),
  );
}
