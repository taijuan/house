import 'package:house/importLib.dart';
import 'package:shared_preferences/shared_preferences.dart';

void pop<T extends Object>(BuildContext context, {T result}) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop<T>(result);
  }
}

Future<T> push<T extends Object>(BuildContext context, Widget route) {
  return Navigator.of(context).push<T>(
    MaterialPageRoute(
      builder: (context) => route,
    ),
  );
}

Future<T> pushReplacement<T extends Object>(
    BuildContext context, Widget route) {
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
  return pushAndRemoveUntil(context, Login(), name: name);
}

void loginSuccessToNavigator(
  BuildContext context, {
  bool isFromWelCome: false,
}) async {
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
  switch (Provide.value<ProviderUser>(context).typeValue) {
    case 1:
      return AgencyHome();
    case 2:
      return LandlordHome();
    case 3:
      return TenantHome();
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
  return Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => route,
    ),
    ModalRoute.withName(name),
  );
}
