import 'package:house/importLib.dart';

class VendorDetailHome extends BaseStatefulWidget {
  final String userId;

  VendorDetailHome(this.userId);

  @override
  _VendorDetailHomeState createState() => _VendorDetailHomeState();
}

class _VendorDetailHomeState extends BaseAppBarAndBodyState<VendorDetailHome> {
  User _data;

  @override
  BaseAppBar appBar(BuildContext context) => TitleAppBar(
        context: context,
        title: TitleAppBar.appBarTitle(
          HouseValue.of(context).vendorDetail,
        ),
        navigatorBack: TitleAppBar.navigatorBackBlack(context),
      );

  @override
  Widget body(BuildContext context) {
    return RefreshCustomScrollView(
      slivers: _data == null
          ? []
          : [
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    DataUtils.isEmpty(_data.companyName)
                        ? (DataUtils.isEmpty(_data.firstName)
                            ? _data.email
                            : _data.firstName)
                        : _data.companyName,
                    style: createTextStyle(
                      fontSize: 17,
                      fontFamily: fontFamilySemiBold,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: FlatButton(
                  onPressed: () {
                    push(context, CertificateListPage(userId: _data.id));
                  },
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        child: Text(
                          HouseValue.of(context).type,
                          style: createTextStyle(color: HouseColor.gray),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _getTags() ?? "",
                          style:
                              createTextStyle(fontFamily: fontFamilySemiBold),
                        ),
                      ),
                      Transform.rotate(
                        angle: pi,
                        child: Icon(
                          HouseIcons.backIcon,
                          size: 16,
                          color: HouseColor.gray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 1,
                  color: HouseColor.divider,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SliverToBoxAdapter(
                child: FlatButton(
                  onPressed: () {},
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        child: Text(
                          HouseValue.of(context).area,
                          style: createTextStyle(color: HouseColor.gray),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _getAreaStr(_data.areaList),
                          style:
                              createTextStyle(fontFamily: fontFamilySemiBold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 1,
                  color: HouseColor.divider,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SliverToBoxAdapter(
                child: FlatButton(
                  onPressed: () {
                    IntentUtils.tel(_data.tel);
                  },
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        child: Text(
                          HouseValue.of(context).phone,
                          style: createTextStyle(color: HouseColor.gray),
                        ),
                      ),
                      Text(
                        _data.tel ?? "",
                        style: createTextStyle(
                          fontSize: 17,
                          fontFamily: fontFamilySemiBold,
                        ),
                      ),
                      Container(
                        width: 8,
                      ),
                      Icon(
                        HouseIcons.phoneIcon,
                        color: HouseColor.green,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 1,
                  color: HouseColor.divider,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SliverToBoxAdapter(
                child: FlatButton(
                  onPressed: () {
                    IntentUtils.geo(_data.address);
                  },
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        child: Text(
                          HouseValue.of(context).address,
                          style: createTextStyle(color: HouseColor.gray),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _data.address ?? "",
                          style: createTextStyle(
                            fontSize: 17,
                            fontFamily: fontFamilySemiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 1,
                  color: HouseColor.divider,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    HouseValue.of(context).description,
                    style: createTextStyle(fontFamily: fontFamilySemiBold),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    _data.companyProfile ?? "",
                    style: createTextStyle(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 8,
                ),
              ),
            ],
      onRefresh: () async {
        await getUserDetail(
          context,
          widget.userId,
          cancelToken: cancelToken,
        ).then((user) {
          _data = user;
        }).catchError((e) {
          showToast(context, e.toString());
        }).whenComplete(() {
          setState(() {});
        });
      },
    );
  }

  String _getAreaStr(List<CityArea> data) {
    if (DataUtils.isEmptyList(data)) {
      return "";
    } else {
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

  String _getTags() {
    if (DataUtils.isEmptyList(_data.certificateList)) {
      return "";
    } else {
      return _data.certificateList.map((v) {
        return v.typeName;
      }).reduce((a, b) {
        return "$a , $b";
      });
    }
  }
}
