import 'package:house/importLib.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPage extends BaseStatefulWidget {
  static const String house_type = "house_type";
  static const String house_area = "house_area";
  static const String vendor_type = "vendor_type";
  static const String vendor_area = "vendor_area";
  final bool isFromHouse;

  FilterPage({
    this.isFromHouse = true,
  });

  @override
  BaseState createState() => _FilterPageState();
}

class _FilterPageState extends BaseAppBarAndBodyState<FilterPage> {
  List<TypeStatus> houseTypes = [];
  List<CityArea> areas = [];
  List<Tag> tags = [];

  @override
  BaseAppBar appBar(BuildContext context) => TitleAppBar(
        context: context,
        title: TitleAppBar.appBarTitle(
          HouseValue.of(context).filter,
        ),
        navigatorBack: TitleAppBar.navigatorBackBlack(
          context,
          back: Text(
            HouseValue.of(context).cancel,
            style: createTextStyle(color: HouseColor.green),
          ),
        ),
        menu: TitleAppBar.appBarMenu(context, onPressed: () {
          SharedPreferences.getInstance().then((sp) {
            if (widget.isFromHouse) {
              sp.setString(FilterPage.house_type, json.encode(houseTypes));
              sp.setString(FilterPage.house_area, json.encode(areas));
            } else {
              sp.setString(FilterPage.vendor_type, json.encode(tags));
              sp.setString(FilterPage.vendor_area, json.encode(areas));
            }
            pop(context, result: true);
          });
        }),
      );

  @override
  void initState() {
    SharedPreferences.getInstance().then((sp) {
      if (widget.isFromHouse) {
        List<dynamic> a =
            json.decode(sp.getString(FilterPage.house_type) ?? "[]") ?? [];
        List<TypeStatus> aa = a.map((a) {
          return TypeStatus.fromJson(a);
        }).toList();
        if (!DataUtils.isEmptyList(aa)) {
          houseTypes.clear();
          houseTypes.addAll(aa);
        }
        String b = sp.getString(FilterPage.house_area) ?? "[]";
        List<dynamic> bb = json.decode(b) ?? [];
        List<CityArea> bbb = bb.map((a) {
          return CityArea.fromJson(a);
        }).toList();
        if (!DataUtils.isEmptyList(bbb)) {
          areas.clear();
          areas.addAll(bbb);
        }
      } else {
        List<dynamic> a =
            json.decode(sp.getString(FilterPage.vendor_type) ?? "[]") ?? [];
        List<Tag> aa = a.map((a) {
          return Tag.fromJson(a);
        }).toList();
        if (!DataUtils.isEmptyList(aa)) {
          tags.clear();
          tags.addAll(aa);
        }
        String b = sp.getString(FilterPage.vendor_area) ?? "[]";
        List<dynamic> bb = json.decode(b) ?? [];
        List<CityArea> bbb = bb.map((a) {
          return CityArea.fromJson(a);
        }).toList();
        if (!DataUtils.isEmptyList(bbb)) {
          areas.clear();
          areas.addAll(bbb);
        }
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget body(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        widget.isFromHouse ? _buildHouseType() : _buildVendorTags(),
        SliverToBoxAdapter(
          child: Container(
            height: .5,
            margin: EdgeInsets.symmetric(horizontal: 12),
            color: HouseColor.divider,
          ),
        ),
        _buildArea(),
        SliverToBoxAdapter(
          child: Container(
            height: .5,
            margin: EdgeInsets.symmetric(horizontal: 12),
            color: HouseColor.divider,
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildArea() {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () {
            push<List<CityArea>>(
              context,
              CityAreaHome(
                selectData: areas,
              ),
            ).then((areas) {
              if (areas != null) {
                this.areas.clear();
                this.areas.addAll(areas);
                setState(() {});
              }
            });
          },
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
                  _getAreaStr(areas),
                  style: createTextStyle(fontFamily: fontFamilySemiBold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHouseType() {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () {
            push<List<TypeStatus>>(
              context,
              HouseTagPage(houseTypes),
            ).then((tags) {
              if (tags != null) {
                this.houseTypes.clear();
                this.houseTypes.addAll(tags);
                setState(() {});
              }
            });
          },
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 80,
                child: Text(
                  HouseValue.of(context).type,
                  style: createTextStyle(color: HouseColor.gray),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  _getHouseTags(),
                  style: createTextStyle(fontFamily: fontFamilySemiBold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildVendorTags() {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () {
            push<List<Tag>>(
              context,
              TagHome(selectData: tags),
            ).then((tags) {
              if (tags != null) {
                this.tags.clear();
                this.tags.addAll(tags);
                setState(() {});
              }
            });
          },
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 80,
                child: Text(
                  HouseValue.of(context).type,
                  style: createTextStyle(color: HouseColor.gray),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  _getVendorTags(),
                  style: createTextStyle(fontFamily: fontFamilySemiBold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
        ),
      ),
    );
  }

  String _getAreaStr(List<CityArea> data) {
    if (DataUtils.isEmptyList(data)) {
      return "";
    } else {
      return data.where((value) {
        return value.checked || !DataUtils.isEmptyList(value.districtList);
      }).map((value) {
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
          return "$a, $b";
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

  String _getHouseTags() {
    if (houseTypes.isEmpty) {
      return "";
    } else {
      return houseTypes.map((tag) {
        return tag.descEn;
      }).reduce((a, b) {
        return "$a, $b";
      });
    }
  }

  String _getVendorTags() {
    if (tags.isEmpty) {
      return "";
    } else {
      return tags.map((tag) {
        return tag.name;
      }).reduce((a, b) {
        return "$a,$b";
      });
    }
  }
}
