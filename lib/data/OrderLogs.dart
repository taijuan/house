class OrderLogs {
  String name;
  String repairOrderId;
  String dateTime;
  bool checked = false;

  OrderLogs.fromJson(Map<String, dynamic> json) {
    this.repairOrderId = json["repairOrderId"];
    this.dateTime = json["dateTime"];
  }
}
