import 'package:house/importLib.dart';

typedef Future<void> OnSaveWhenComplete();

class ProviderUser extends ChangeNotifier {
  final User user = User.fromJson({});

  String get userId => user.id;

  //用户类型值
  int get typeValue => user.type.value;

  bool isAgent() {
    return typeValue == TypeStatus.agent.value;
  }

  bool isLandlord() {
    return typeValue == TypeStatus.landlord.value;
  }

  bool isTenant() {
    return typeValue == TypeStatus.tenant.value;
  }

  bool isVendor() {
    return typeValue == TypeStatus.vendor.value;
  }

  void save(
    User user, {
    OnSaveWhenComplete onSaveWhenComplete,
  }) async {
    this.user.id = user.id;
    this.user.account = user.account;
    this.user.password = user.password;
    this.user.headImage = user.headImage;
    this.user.firstName = user.firstName;
    this.user.lastName = user.lastName;
    this.user.imgStr = user.imgStr;
    this.user.imageName = user.imageName;
    this.user.email = user.email;
    this.user.type = user.type;
    this.user.status = user.status;
    this.user.companyName = user.companyName;
    this.user.address = user.address;
    this.user.tel = user.tel;
    this.user.companyProfile = user.companyProfile;
    this.user.certificateList = user.certificateList;
    this.user.areaList = user.areaList;
    this.user.areaStr = await _getArea();
    await user.saveUser();
    notifyListeners();
    if (onSaveWhenComplete != null) {
      onSaveWhenComplete();
    }
  }

  void clear(BuildContext context) async {
    this.user.id = null;
    this.user.account = null;
    this.user.password = null;
    this.user.headImage = null;
    this.user.firstName = null;
    this.user.lastName = null;
    this.user.imgStr = null;
    this.user.imageName = null;
    this.user.email = null;
    this.user.type = null;
    this.user.status = null;
    this.user.companyName = null;
    this.user.address = null;
    this.user.tel = null;
    this.user.companyProfile = null;
    this.user.certificateList = null;
    this.user.areaList = null;
    this.user.areaStr = null;
    await User.clear();
    pushLogin(context);
  }

  Future<String> _getArea() async {
    return _getAreaStr(user.areaList);
  }

  String _getAreaStr(List<CityArea> data) {
    if (DataUtils.isEmptyList(data)) {
      return "";
    } else {
      data.sort(
        (a, b) => b.checked.toString().compareTo(
              a.checked.toString(),
            ),
      );
      List<CityArea> a = data.where((value) {
        return value.checked || !DataUtils.isEmptyList(value.districtList);
      }).toList();
      if (DataUtils.isEmptyList(a)) {
        return "";
      }
      return a.map((value) {
        if (value.checked) {
          return value.name;
        } else {
          return _getNextAreaStr(value.districtList);
        }
      }).reduce((a, b) {
        if (DataUtils.isEmpty(a) && DataUtils.isEmpty(b)) {
          return "";
        } else if (DataUtils.isEmpty(a)) {
          return b;
        } else if (DataUtils.isEmpty(b)) {
          return a;
        } else {
          return "$a，$b";
        }
      });
    }
  }

  String _getNextAreaStr(List<CityArea> data) {
    if (DataUtils.isEmptyList(data)) {
      return "";
    } else {
      return data.map((value) {
        return value.name;
      }).reduce((a, b) {
        if (DataUtils.isEmpty(a) && DataUtils.isEmpty(b)) {
          return "";
        } else if (DataUtils.isEmpty(a)) {
          return b;
        } else if (DataUtils.isEmpty(b)) {
          return a;
        } else {
          return "$a，$b";
        }
      });
    }
  }
}
