import 'dart:core';

const List<String> months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

///format MMM d,yyyy
///format MMM d,yyyy
String dateTime2String(DateTime time) {
  return "${months[time.month - DateTime.january]} ${time.day},${time.year}";
}

/// format MMM d,yyyy
DateTime string2DateTime(String time) {
  DateTime now = DateTime.now();
  if (time == null || time.isEmpty) {
    return now;
  }
  List<String> regs = time.split(RegExp("[ ,]+"));
  if (regs.length != 3) {
    return now;
  }

  int year = int.tryParse(regs[2]) ?? now.year;
  int mouth = months.indexOf(regs[0]) + DateTime.january;
  if (mouth < 0 || mouth > 12) {
    mouth = now.month;
  }
  int day = int.tryParse(regs[1]) ?? now.day;
  return DateTime(year, mouth, day);
}
