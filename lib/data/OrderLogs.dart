class OrderLogs {
  String name;
  String dateTime;

  /// 0：未进行 1：已进行 2：进行中
  int status = 0;

  OrderLogs.fromJson(Map<String, dynamic> json) {
    this.dateTime = json["dateTime"] ?? "";
  }
}
