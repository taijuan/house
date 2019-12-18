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
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    backgroundColor = HouseColor.lightGray;
    SharedPreferences.getInstance().then((sp) {
      setState(() {
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
  Future<bool> didPopRoute() {
    print("didPopRoute");
    return super.didPopRoute();
  }
  @override
  Future<bool> didPushRoute(String route) {
    print("didPushRoute");
    return super.didPushRoute(route);
  }
  @override
  void didUpdateWidget(HouseHome oldWidget) {
    print("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
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
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 64),
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
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
            FocusScope.of(context).unfocus();
            Provide.value<ProviderHouseReLoad>(context).reLoad();
          },
        ),
      ),
      menu: TitleAppBar.appBarMenu(
        context,
        onPressed: () {
          push(context, FilterPage());
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
    return IndexedStack(
      index: _isShowMap ? 1 : 0,
      children: <Widget>[
        Provide<ProviderHouseReLoad>(
          builder: (context, child, reload) => _houseList(reload.reloadNum),
        ),
        Provide<ProviderHouseReLoad>(
          builder: (context, child, reload) => MapHome(
            key: ValueKey(reload.reloadNum),
          ),
        ),
      ],
    );
  }

  Widget _houseList(int num) {
    LogUtils.log(num);
    return RefreshListView(
      padding: EdgeInsets.symmetric(vertical: 12),
      key: ValueKey(num),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: HouseBigCard(_data[index]),
      ),
      separatorBuilder: (context, index) => Container(height: 12),
      itemCount: _data.length,
      onRefresh: () async {
        await getHouseList(
          context,
          1,
          cancelToken: cancelToken,
        ).then((data) {
          this._data.clear();
          this._data.addAll(data);
        }).catchError((e) {
          showToast(context, e.toString());
        }).whenComplete(() {
          setState(() {});
        });
      },
      onLoadMore: (page) async {
        await getHouseList(
          context,
          page,
          cancelToken: cancelToken,
        ).then((data) {
          this._data.addAll(data);
        }).catchError((e) {
          showToast(context, e.toString());
        }).whenComplete(() {
          setState(() {});
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
