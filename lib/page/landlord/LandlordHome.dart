import 'package:house/importLib.dart';

class LandlordHome extends BaseStatefulWidget {
  @override
  _LandlordHomeState createState() {
    return _LandlordHomeState();
  }
}

class _LandlordHomeState extends BaseAppBarAndBodyState<LandlordHome> {
  final GlobalKey<RefreshWidgetState> _refreshKey =
      GlobalKey<RefreshWidgetState>();
  final List<House> _data = [];
  int _curPage = 1;

  @override
  void initState() {
    backgroundColor = HouseColor.lightGray;
    Future.delayed(Duration()).whenComplete(() {
      _refreshKey.currentState.show();
    });
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      navigatorBack: Container(),
      title: TitleAppBar.appBarTitle(
        TypeStatus.userType[1].descEn,
        style: createTextStyle(
          color: HouseColor.white,
          fontSize: 17,
          fontFamily: fontFamilySemiBold,
        ),
      ),
      decoration: BoxDecoration(color: HouseColor.green),
      menu: TitleAppBar.menuToMe(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshWidget(
      key: _refreshKey,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index.isOdd) {
                var data = _data[index ~/ 2];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: HouseBigCard(
                    data,
                    onPressed: () {
                      push(context, LandlordOrderListHome(data));
                    },
                  ),
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
          _refreshKey.currentState.error();
          showToast(context, e.toString());
        });
      },
    );
  }
}