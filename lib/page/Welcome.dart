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
    List<Permission> permissions = [];
    if (Platform.isAndroid) {
      permissions.add(Permission.location);
      permissions.add(Permission.storage);
    }
    if (Platform.isIOS) {
      permissions.add(Permission.locationWhenInUse);
      permissions.add(Permission.locationAlways);
      permissions.add(Permission.photos);
    }
    permissions.request().then((values) {
      Future.delayed(const Duration(seconds: 2), () {
        loginSuccessToNavigator(context, isFromWelCome: true);
      });
    });
    PaintingBinding.instance.imageCache
      ..maximumSize = 1000
      ..maximumSizeBytes = 500 << 20;
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
