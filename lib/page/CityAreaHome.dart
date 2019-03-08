import 'package:house/importLib.dart';

class CityAreaHome extends BaseStatefulWidget {
  final String title;
  final List<CityArea> selectData;
  final String pid;

  CityAreaHome({
    this.title,
    this.selectData,
    this.pid,
  });

  @override
  _CityAreaHomeListState createState() {
    return _CityAreaHomeListState();
  }
}

class _CityAreaHomeListState extends BaseAppBarAndBodyState<CityAreaHome> {
  final GlobalKey<RefreshIndicatorState> _globalKey =
      GlobalKey<RefreshIndicatorState>();
  final List<CityArea> _data = [];

  @override
  void initState() {
    Future.delayed(Duration()).whenComplete(() {
      _globalKey.currentState.show();
    });
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(
        widget.title ?? HouseValue.of(context).city,
      ),
      navigatorBack: TitleAppBar.navigatorBackBlack(context, onPressed: () {
        pop<List<CityArea>>(context, result: null);
      }),
      menu: TitleAppBar.appBarMenu(context, onPressed: () {
        pop<List<CityArea>>(context,
            result: _data.where((value) {
              return value.checked ||
                  !DataUtils.isEmptyList(value.districtList);
            }).toList());
      }),
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshIndicator(
      key: _globalKey,
      semanticsLabel: "",
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (_, index) {
              if (index.isEven) {
                return _buildItem(_data[index ~/ 2]);
              } else {
                return Container(
                  height: .5,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  color: HouseColor.divider,
                );
              }
            },
            childCount: _data.length * 2,
          ))
        ],
      ),
      onRefresh: () async {
        await getCityList(
          context,
          pid: widget.pid,
          cancelToken: cancelToken,
        ).then((data) async {
          await _setData(data);
          setState(() {});
        }).catchError((e) {
          LogUtils.log(e);
          showToast(context, e.toString());
        });
      },
    );
  }

  Future _setData(List<CityArea> data) async {
    this._data.clear();
    this._data.addAll(data);
    this._data.forEach((a) {
      CityArea aa = widget.selectData.firstWhere((b) {
        return a.id == b.id;
      }, orElse: () {
        return null;
      });
      if (aa != null) {
        a.checked = aa.checked;
        a.districtList = aa.districtList;
      }
    });
  }

  Widget _buildItem(CityArea data) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          widget.pid == null
              ? _checkName(data)
              : Expanded(
                  child: _checkName(data),
                ),
          widget.pid == null
              ? Expanded(
                  child: _selectArea(data),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  FlatButton _selectArea(CityArea data) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 16),
      onPressed: () {
        push<List<CityArea>>(
          context,
          CityAreaHome(
            title: HouseValue.of(context).area,
            pid: data.id,
            selectData: data.districtList,
          ),
        ).then((areaList) {
          if (areaList != null) {
            data.districtList.clear();
            data.districtList.addAll(areaList);
            setState(() {});
          }
        });
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              _getAreaStr(data),
              style: createTextStyle(color: HouseColor.green, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Transform.rotate(
            angle: pi / 2,
            child: Image.asset("image/house_fold.webp"),
          )
        ],
      ),
    );
  }

  String _getAreaStr(CityArea data) {
    if (data.checked) {
      return "";
    } else if (DataUtils.isEmptyList(data.districtList)) {
      return "";
    } else {
      return data.districtList.map((v) {
        v.checked = true;
        return v.name;
      }).reduce((a, b) {
        return "$a，$b";
      });
    }
  }

  FlatButton _checkName(CityArea data) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 16),
      onPressed: () {
        data.checked = !data.checked;
        setState(() {});
      },
      child: Row(
        mainAxisSize: widget.pid == null ? MainAxisSize.min : MainAxisSize.max,
        children: <Widget>[
          Image.asset(
            data.checked
                ? "image/house_auth_select.webp"
                : "image/house_auth_unselect.webp",
            width: 18,
            height: 18,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            data.name,
            style: createTextStyle(),
          )
        ],
      ),
    );
  }
}
