import 'package:house/importLib.dart';
import 'package:house/utils/DataUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
  String account;
  String password;
  String headImage;
  String firstName;
  String lastName;
  File imgStr;
  String imageName;
  String email;
  TypeStatus type;
  TypeStatus status;
  String companyName;
  String address;
  String tel;
  String companyProfile;
  List<Certificate> certificateList;
  List<CityArea> areaList;

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        account = json["account"] ?? "",
        password = json["password"],
        headImage = json["headImage"] ?? "",
        firstName = json["firstName"] ?? "",
        lastName = json["lastName"] ?? "",
        email = json["email"],
        type = TypeStatus.fromJson(DataUtils.isMap(json["type"])),
        status = TypeStatus.fromJson(DataUtils.isMap(json["status"])),
        companyName = json["companyName"] ?? "",
        address = json["address"] ?? "",
        tel = json["tel"] ?? "",
        companyProfile = json["companyProfile"] ?? "",
        certificateList = DataUtils.isList(json["certificateList"]).map((a) {
          return Certificate.fromJson(a);
        }).toList(),
        areaList = DataUtils.isList(json["areaList"]).map((a) {
          return CityArea.fromJson(a);
        }).toList();

  Map<String, dynamic> toJson() => {
        "id": id,
        "account": account,
        "password": password,
        "headImage": headImage,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "type": type.toJson(),
        "status": status.toJson(),
        "companyName": companyName,
        "address": address,
        "tel": tel,
        "companyProfile": companyProfile,
        "certificateList": certificateList,
        "areaList": areaList,
      };

  static User user;

  void saveUser() async {
    user = this;
    await (await SharedPreferences.getInstance())
        .setString("user", json.encode(this));
  }

  String getUserName() {
    if (DataUtils.isEmpty(firstName) && DataUtils.isEmpty(lastName)) {
      return email ?? "";
    } else if (DataUtils.isEmpty(firstName)) {
      return lastName;
    } else if (DataUtils.isEmpty(lastName)) {
      return firstName;
    } else {
      return "$firstName · $lastName";
    }
  }

  static User getUserSync() {
    return user;
  }

  static Future<User> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String value = sharedPreferences.getString("user");
    user = value == null ? null : User.fromJson(json.decode(value));
    return user;
  }

  static void clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("user");
  }
}
