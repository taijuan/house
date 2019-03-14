class Repair {
  String typeNames;
  String companyName;
  String createTime;

  Repair.fromJson(Map<String, dynamic> json) {
    this.typeNames = json["typeNames"] ?? "";
    this.companyName = json["companyName"] ?? "维修商名称";
    this.createTime = json["createTime"] ?? "";
  }
}
