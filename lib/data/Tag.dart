class Tag {
  String id;
  String name;
  String desc;
  bool checked = false;

  Tag.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        desc = json["desc"] ?? "",
        checked = json["checked"] ?? false;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "checked": checked,
      };
}
