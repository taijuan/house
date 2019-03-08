import 'package:house/importLib.dart';
import 'package:shared_preferences/shared_preferences.dart';

void pop<T extends Object>(BuildContext context, {T result}) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop<T>(result);
  }
}

Future<T> push<T extends Object>(BuildContext context, Widget route) {
  return Navigator.push<T>(
    context,
    MaterialPageRoute(
      builder: (context) => route,
    ),
  );
}

Future<T> pushReplacement<T extends Object>(
    BuildContext context, Widget route) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => route,
    ),
  );
}

Future<T> pushLogin<T extends Object>(
  BuildContext context, {
  String name: "/",
}) {
  User.clear();
  return pushAndRemoveUntil(context, Login(), name: name);
}

void loginSuccessToNavigator(
  BuildContext context, {
  bool isFromWelCome: false,
}) async {
  User user = await User.getUser();
  LogUtils.log(json.encode(user));
  if (isFromWelCome) {
    String oldVersionCode =
        (await SharedPreferences.getInstance()).getString("versionCode") ?? "";
    String versionCode = (await PackageInfo.fromPlatform()).buildNumber ?? "";
    if (versionCode.compareTo(oldVersionCode) > 0) {
      pushReplacement(context, GuidePage());
    } else {
      pushReplacement(context, route(user));
    }
  } else {
    pushAndRemoveUntil(context, route(user));
  }
}

Widget route(User user) {
  switch (user?.type?.value) {
    case 1:
      return AgencyHome();
    case 2:
      return LandlordHome();
    case 3:
      return LesseeHome();
    case 4:
      return VendorHome();
  }
  return Login();
}

Future<T> pushAndRemoveUntil<T extends Object>(
  BuildContext context,
  Widget route, {
  String name: "/",
}) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => route,
    ),
    ModalRoute.withName(name),
  );
}
