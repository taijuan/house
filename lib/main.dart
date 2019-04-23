import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house/importLib.dart';

void main() async {
  const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: HouseColor.transparent,
    systemNavigationBarDividerColor: HouseColor.transparent,
    statusBarColor: HouseColor.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
  SystemChrome.setSystemUIOverlayStyle(dark);

  User user = await User.getUser();
  var providers = Providers()
    ..provide(Provider<ProviderUser>.value(ProviderUser()..save(user)))
    ..provide(Provider<ProviderHouseReLoad>.value(ProviderHouseReLoad()))
    ..provide(Provider<ProviderVendorReLoad>.value(ProviderVendorReLoad()))
    ..provide(Provider<ProviderOrderReLoad>.value(ProviderOrderReLoad()));
  return runApp(ProviderNode(child: HouseApp(), providers: providers));
}

class HouseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.light().copyWith(
          backgroundColor: HouseColor.white,
          scaffoldBackgroundColor: HouseColor.white,
          dialogBackgroundColor: HouseColor.white,
          platform: TargetPlatform.iOS,
          buttonTheme: ThemeData.light().buttonTheme.copyWith(
                minWidth: 48,
                height: 36,
                padding: EdgeInsets.only(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
          textTheme: ThemeData.light().textTheme.copyWith(
                caption: TextStyle(
                  color: HouseColor.gray,
                ),
              ),
        ),
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
        ],
        locale: Locale("en"),
        supportedLocales: [
          Locale("zh", ""),
          Locale("en", ""),
        ],
        routes: {
          "/": (_) {
            return Welcome();
          },
        },
      );
}
