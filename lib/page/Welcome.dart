import 'dart:async';

import 'package:house/importLib.dart';
import 'package:permission_handler/permission_handler.dart';

@override
class Welcome extends BaseStatefulWidget {
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends BaseState<Welcome> {
  @override
  void initState() {
    List<PermissionGroup> permissions = [];
    if (Platform.isAndroid) {
      permissions.add(PermissionGroup.location);
      permissions.add(PermissionGroup.storage);
    }
    if (Platform.isIOS) {
      permissions.add(PermissionGroup.locationWhenInUse);
      permissions.add(PermissionGroup.locationAlways);
      permissions.add(PermissionGroup.photos);
    }
    PermissionHandler().requestPermissions(permissions).then((values) {
      Future.delayed(const Duration(seconds: 2), () {
        loginSuccessToNavigator(context, isFromWelCome: true);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        "image/launch_background.webp",
        fit: BoxFit.fill,
      ),
    );
  }
}
