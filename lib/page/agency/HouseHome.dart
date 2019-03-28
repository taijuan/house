import 'package:flutter/services.dart';
import 'package:house/importLib.dart';
import 'package:house/page/agency/MapHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseHome extends BaseStatefulWidget {
  @override
  _HouseHomeState createState() {
    return _HouseHomeState();
  }
}

class _HouseHomeState extends BaseAppBarAndBodyState<HouseHome> {
  final List<House> _data = [];
  bool _isShowMap = false;
  final GlobalKey<RefreshWidgetState> _refreshKey =
      GlobalKey<RefreshWidgetState>();
  final GlobalKey<MapHomeState> _refreshMapKey = GlobalKey<MapHomeState>();
  int _curPage = 1;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    backgroundColor = HouseColor.lightGray;
    Future.delayed(Duration()).whenComplete(() {
      _refreshKey.currentState.show();
    });
    SharedPreferences.getInstance().then((sp){
     setState((){
       _controller.text = sp.getString("address");
     });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      decoration: BoxDecoration(color: HouseColor.white),
      navigatorBack: TitleAppBar.navigatorBackBlack(
        context,
        onPressed: () {
          setState(() {
            this._isShowMap = !this._isShowMap;
          });
        },
        back: Text(
          _isShowMap ? HouseValue.of(context).list : HouseValue.of(context).map,
          style: createTextStyle(
            color: HouseColor.green,
          ),
        ),
      ),
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 64),
        child: TextField(
          decoration: InputDecoration(
            fillColor: HouseColor.lightGray,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: HouseColor.gray, width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HouseColor.gray, width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HouseColor.lightGreen, width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            hintText: String.fromCharCode(
              HouseIcons.searchIcon.codePoint,
            ),
            hintStyle: createTextStyle(
              fontSize: 16,
              fontFamily: "iconfont",
              color: HouseColor.gray,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
          ),
          maxLines: 1,
          inputFormatters: [LengthLimitingTextInputFormatter(30)],
          controller: _controller,
          textInputAction: TextInputAction.search,
          onChanged: (str) {
            SharedPreferences.getInstance().then((sp) {
              sp.setString("address", str);
            });
          },
          onEditingComplete: () {
            FocusScope.of(context).detach();
            if (_isShowMap) {
              _refreshMapKey.currentState.queryHouse();
            } else {
              _refreshKey.currentState.show();
            }
          },
        ),
      ),
      menu: TitleAppBar.appBarMenu(
        context,
        onPressed: () {
          push(
            context,
            FilterPage(),
          ).then((result) {
            if (result != null) {
              if (_isShowMap) {
                _refreshMapKey.currentState.queryHouse();
              } else {
                _refreshKey.currentState.show();
              }
            }
          });
        },
        menu: Text(
          HouseValue.of(context).filter,
          style: createTextStyle(color: HouseColor.green),
        ),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    if (_isShowMap) {
      return MapHome(key: _refreshMapKey);
    } else {
      return RefreshWidget(
        key: _refreshKey,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index.isOdd) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: HouseBigCard(_data[index ~/ 2]),
                  );
                } else {
                  return SizedBox(
                    height: 12,
                  );
                }
              },
              childCount: _data.length * 2,
            ),
          )
        ],
        onRefresh: () async {
          await getHouseList(
            context,
            1,
            cancelToken: cancelToken,
          ).then((data) {
            this._data.clear();
            this._data.addAll(data);
            if (data.length >= 10) {
              _refreshKey.currentState.more();
            } else {
              _refreshKey.currentState.noMore();
            }
            _curPage = 1;
            setState(() {});
          }).catchError((e) {
            showToast(context, e.toString());
            setState(() {});
          });
        },
        onLoadMore: () async {
          await getHouseList(
            context,
            _curPage + 1,
            cancelToken: cancelToken,
          ).then((data) {
            this._data.addAll(data);
            if (data.length >= 10) {
              _refreshKey.currentState.more();
            } else {
              _refreshKey.currentState.noMore();
            }
            _curPage++;
            setState(() {});
          }).catchError((e) {
            showToast(context, e.toString());
            _refreshKey.currentState.error();
            setState(() {});
          });
        },
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
