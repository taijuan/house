import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house/importLib.dart';

void main() {
  const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: HouseColor.transparent,
    systemNavigationBarDividerColor: HouseColor.transparent,
    statusBarColor: HouseColor.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
  SystemChrome.setSystemUIOverlayStyle(dark);
  return runApp(
    MaterialApp(
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
      routes: {
        "/": (_) {
          return Welcome();
        },
      },
    ),
  );
}
