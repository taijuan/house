import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house/importLib.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  return runApp(
    MaterialApp(
      theme: ThemeData.light().copyWith(
        backgroundColor: HouseColor.white,
        scaffoldBackgroundColor: HouseColor.white,
        dialogBackgroundColor: HouseColor.white,
        buttonTheme: ButtonThemeData(
          minWidth: 48,
          height: 36,
          padding: EdgeInsets.only(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        textTheme: TextTheme(
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
