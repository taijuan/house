import 'package:house/importLib.dart';

class ProfileHome extends BaseStatefulWidget {
  @override
  _ProfileHomeState createState() {
    return _ProfileHomeState();
  }
}

class _ProfileHomeState extends BaseAppBarAndBodyState<ProfileHome> {
//  final List<CityArea> cityList = [];

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).profile,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Provide<ProviderUser>(
      builder: (context, child, data) {
        User user = data.user;
        return ListView(
          padding: EdgeInsets.only(),
          children: [
            ///firstName
            _nameAndValue(
              onPressed: () {
                push(context, ChangeName());
              },
              name: HouseValue.of(context).firstName,
              value: user.firstName,
            ),

            ///lastName
            _nameAndValue(
              onPressed: () {
                push(context, ChangeName());
              },
              name: HouseValue.of(context).lastName,
              value: user.lastName,
            ),

            ///修改邮箱
            _nameAndValue(
              onPressed: () {
                push(context, ChangeEmail());
              },
              name: HouseValue.of(context).email,
              value: user.email,
            ),

            ///电话
            _nameAndValue(
              onPressed: () {
                push(context, ChangePhone());
              },
              name: HouseValue.of(context).phone,
              value: user.tel,
            ),

            ///修改密码
            _nameAndValue(
              onPressed: () {
                push(context, ChangePassword());
              },
              name: HouseValue.of(context).password,
              value: "",
            ),
            _nameAndValue(
              onPressed: () {
                push(
                  context,
                  TextFieldPage(
                    HouseValue.of(context).companyName,
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
              name: HouseValue.of(context).companyName,
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
                      return v.checked ||
                          !DataUtils.isEmptyList(v.districtList);
                    }).toList(),
                  ),
                ).then((area) {
                  if (area != null) {
                    _modifyUserInfo(cityArea: area);
                  }
                });
              },
              name: HouseValue.of(context).area,
              value: user.areaStr,
              showNull: user.type.value != TypeStatus.vendor.value,
            ),
            _nameAndValue(
              onPressed: () {
                push(
                  context,
                  TextFieldPage(
                    HouseValue.of(context).address,
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
              name: HouseValue.of(context).address,
              value: user.address,
              showNull: user.type.value != TypeStatus.vendor.value,
            ),
            _nameAndValue(
              onPressed: () {
                push(
                  context,
                  TextFieldPage(
                    HouseValue.of(context).companyInfo,
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
              name: HouseValue.of(context).companyInfo,
              value: user.companyProfile,
              showNull: user.type.value != TypeStatus.vendor.value,
            ),
          ],
        );
      },
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
            angle: pi,
            child: Icon(
              HouseIcons.backIcon,
              color: HouseColor.gray,
              size: 14,
            ),
          )
        ],
      ),
    );
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
      Provide.value<ProviderUser>(context).save(user);
    }).catchError((e) {
      showToast(context, e.toString());
      pop(context);
    });
  }
}
