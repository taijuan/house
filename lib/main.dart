import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house/importLib.dart';

void main() async {
  //Fix https://github.com/flutter/flutter/issues/38056
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError =(e){
    print(e);
  };
  const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: HouseColor.transparent,
    systemNavigationBarDividerColor: HouseColor.transparent,
    statusBarColor: HouseColor.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
  SystemChrome.setSystemUIOverlayStyle(dark);

  ProviderUser providerUser = ProviderUser();
  await providerUser.save(await User.getUser());
  var providers = Providers()
    ..provide(Provider<ProviderUser>.value(providerUser))
    ..provide(Provider<ProviderHouseReLoad>.value(ProviderHouseReLoad()))
    ..provide(Provider<ProviderVendorReLoad>.value(ProviderVendorReLoad()))
    ..provide(
        Provider<ProviderCertificateReLoad>.value(ProviderCertificateReLoad()))
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
        home: Welcome(),
      );
}
