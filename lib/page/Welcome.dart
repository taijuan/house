import 'dart:async';

import 'package:house/importLib.dart';
import 'package:permission_handler/permission_handler.dart';

@override
class Welcome extends BaseStatefulWidget {
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends BaseState<Welcome> {
  bool hadInit = false;

  @override
  void initState() {
    PermissionHandler().requestPermissions([
      PermissionGroup.storage,
      PermissionGroup.location,
      PermissionGroup.camera
    ]).then((values) {
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
