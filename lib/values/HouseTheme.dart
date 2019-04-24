import 'dart:ui';

import 'package:house/importLib.dart';

const String fontFamilyRegular = "LatoRegular";
const String fontFamilySemiBold = "LatoSemibold";
const String fontFamilyBold = "LatoBold";

TextStyle createTextStyle({
  Color color: HouseColor.black,
  double fontSize: 15,
  String fontFamily: fontFamilyRegular,
  double height: 1.1,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: fontFamily,
    height: height,
  );
}
