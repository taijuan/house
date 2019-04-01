import 'package:house/importLib.dart';

class TenantHousePage extends BaseStatefulWidget {
  @override
  _TenantHousePageState createState() {
    return _TenantHousePageState();
  }
}

class _TenantHousePageState extends BaseAppBarAndBodyState<TenantHousePage> {
  final List<House> _data = [];
  final GlobalKey<RefreshWidgetState> _refreshKey =
      GlobalKey<RefreshWidgetState>();
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
      decoration: BoxDecoration(color: HouseColor.green),
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).properties,
        style: createTextStyle(
          color: HouseColor.white,
          fontSize: 17,
          fontFamily: fontFamilySemiBold,
        ),
      ),
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
                  child: HouseBigCard(data),
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
          } else if (DataUtils.isEmptyList(data)) {
            _refreshKey.currentState.refreshNoData();
          } else {
            _refreshKey.currentState.loadMoreNoData();
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
            _refreshKey.currentState.loadMoreNoData();
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

  @override
  bool get wantKeepAlive => true;
}
