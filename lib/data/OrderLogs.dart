class OrderLogs {
  String name;
  String dateTime;
  bool checked = false;

  OrderLogs.fromJson(Map<String, dynamic> json) {
    this.dateTime = json["dateTime"] ?? "";
  }
}
