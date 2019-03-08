import 'package:house/importLib.dart';

class ProfileHome extends BaseStatefulWidget {
  @override
  _ProfileHomeState createState() {
    return _ProfileHomeState();
  }
}

class _ProfileHomeState extends BaseAppBarAndBodyState<ProfileHome> {
  User user = User.getUserSync();
  final List<CityArea> cityList = [];
  String _area = "";

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() {
    User.getUser().then((user) {
      setState(() {
        this.user = user;
        _getArea();
      });
    });
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      title: TitleAppBar.appBarTitle(
        HouseValue
            .of(context)
            .profile,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(),
      children: [

        ///firstName
        _nameAndValue(
          onPressed: () {
            push(context, ChangeName()).whenComplete(_refresh);
          },
          name: HouseValue
              .of(context)
              .firstName,
          value: user.firstName,
        ),

        ///lastName
        _nameAndValue(
          onPressed: () {
            push(context, ChangeName()).whenComplete(_refresh);
          },
          name: HouseValue
              .of(context)
              .lastName,
          value: user.lastName,
        ),

        ///修改邮箱
        _nameAndValue(
          onPressed: () {
            push(context, ChangeEmail()).whenComplete(_refresh);
          },
          name: HouseValue
              .of(context)
              .email,
          value: user.email,
        ),

        ///电话
        _nameAndValue(
          onPressed: () {
            push(context, ChangePhone()).whenComplete(_refresh);
          },
          name: HouseValue
              .of(context)
              .phone,
          value: user.tel,
        ),

        ///修改密码
        _nameAndValue(
          onPressed: () {
            push(context, ChangePassword()).whenComplete(_refresh);
          },
          name: HouseValue
              .of(context)
              .password,
          value: "",
        ),
        _nameAndValue(
          onPressed: () {
            push(
              context,
              TextFieldPage(
                HouseValue
                    .of(context)
                    .company,
                value: user.companyName,
                maxLength: 100,
                maxLines: 4,
              ),
            ).then((value) {
              if (value != null) {
                _modifyUserInfo(companyName: value);
              }
            });
          },
          name: HouseValue
              .of(context)
              .company,
          value: user.companyName,
          showNull: user.type.value != TypeStatus.vendor.value,
        ),
        _nameAndValue(
          onPressed: () {
            push<List<CityArea>>(
              context,
              CityAreaHome(
                selectData: user.areaList.where((v) {
                  if (v.checked) {
                    v.districtList = [];
                  }
                  return v.checked || !DataUtils.isEmptyList(v.districtList);
                }).toList(),
              ),
            ).then((area) {
              if (area != null) {
                _modifyUserInfo(cityArea: area);
              }
            });
          },
          name: HouseValue
              .of(context)
              .area,
          value: _area,
          showNull: user.type.value != TypeStatus.vendor.value,
        ),
        _nameAndValue(
          onPressed: () {
            push(
              context,
              TextFieldPage(
                HouseValue
                    .of(context)
                    .address,
                value: user.address,
                maxLength: 100,
                maxLines: 4,
              ),
            ).then((value) {
              if (value != null) {
                _modifyUserInfo(address: value);
              }
            });
          },
          name: HouseValue
              .of(context)
              .address,
          value: user.address,
          showNull: user.type.value != TypeStatus.vendor.value,
        ),
        _nameAndValue(
          onPressed: () {
            push(
              context,
              TextFieldPage(
                HouseValue
                    .of(context)
                    .companyInfo,
                value: user.companyProfile,
                maxLength: 600,
                maxLines: 10,
              ),
            ).then((value) {
              if (value != null) {
                _modifyUserInfo(companyProfile: value);
              }
            });
          },
          name: HouseValue
              .of(context)
              .companyInfo,
          value: user.companyProfile,
          showNull: user.type.value != TypeStatus.vendor.value,
        ),
      ],
    );
  }

  Widget _nameAndValue({
    VoidCallback onPressed,
    String name,
    String value,
    bool showNull = false,
  }) {
    if (showNull) {
      return Container(
        width: 0,
        height: 0,
      );
    }
    return RawMaterialButton(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      constraints: BoxConstraints(maxWidth: 0, minHeight: 48),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: onPressed,
      shape: Border(
        bottom: BorderSide(
          color: HouseColor.divider,
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name,
            style: createTextStyle(color: HouseColor.gray),
          ),
          Container(width: 24),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: createTextStyle(),
            ),
          ),
          Container(width: 8),
          Transform.rotate(
            angle: pi / 2,
            child: Image.asset("image/house_fold.webp"),
          )
        ],
      ),
    );
  }

  _getArea() {
    Future<String>(() {
      return _getAreaStr(user.areaList);
    }).then((area) {
      this._area = area;
    }).whenComplete(() {
      setState(() {});
    });
  }

  String _getAreaStr(List<CityArea> data) {
    if (DataUtils.isEmptyList(data)) {
      return "";
    } else {
      data.sort(
            (a, b) =>
            b.checked.toString().compareTo(
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

  void _modifyUserInfo({
    String companyName,
    String companyProfile,
    String address,
    List<CityArea> cityArea,
  }) async {
    showLoadingDialog(context);
    modifyUserInfo(
      context,
      companyName: companyName,
      companyProfile: companyProfile,
      address: address,
      cityArea: cityArea,
      cancelToken: cancelToken,
    ).then((user) {
      pop(context);
      user.saveUser();
      _refresh();
    }).catchError((e) {
      showToast(context, e.toString());
      pop(context);
    });
  }
}
