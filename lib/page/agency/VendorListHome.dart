import 'package:house/importLib.dart';

class VendorListHome extends BaseStatefulWidget {
  @override
  _VendorListHomeState createState() => _VendorListHomeState();
}

class _VendorListHomeState extends BaseAppBarAndBodyState<VendorListHome> {
  final List<User> _data = [];
  final GlobalKey<RefreshWidgetState> _refreshKey =
      GlobalKey<RefreshWidgetState>();
  int _curPage = 1;

  @override
  void initState() {
    Future.delayed(Duration()).whenComplete(() {
      _refreshKey.currentState.show();
    });
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) => TitleAppBar(
        context: context,
        title: TitleAppBar.appBarTitle(HouseValue.of(context).vendorList),
        menu: TitleAppBar.appBarMenu(
          context,
          onPressed: () {
            push(
              context,
              FilterPage(isFromHouse: false),
            ).then((result) {
              if (result != null) {
                _refreshKey.currentState.show();
              }
            });
          },
          menu: Text(
            HouseValue.of(context).filter,
            style: createTextStyle(color: HouseColor.green),
          ),
        ),
      );

  @override
  Widget body(BuildContext context) {
    return RefreshWidget(
      key: _refreshKey,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index.isEven) {
                return _buildItem(_data[index ~/ 2]);
              } else {
                return Container(
                  color: HouseColor.divider,
                  height: .5,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                );
              }
            },
            childCount: _data.length * 2,
          ),
        )
      ],
      onRefresh: () async {
        await queryRepairUsers(
          context,
          1,
          cancelToken: cancelToken,
        ).then((data) {
          this._data.clear();
          this._data.addAll(data);
          if (data.length >= 10) {
            _refreshKey.currentState.more();
          } else {
            _refreshKey.currentState.refreshNoData();
          }
          _curPage = 1;
          setState(() {});
        }).catchError((e) {
          showToast(context, e.toString());
        });
      },
      onLoadMore: () async {
        await queryRepairUsers(
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

  Widget _buildItem(User data) {
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      onPressed: () {
        push(context, VendorDetailHome(data.id));
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            HouseCacheNetworkImage(
              DataUtils.getImageUrl(data.headImage),
              width: 60,
              height: 60,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    data.companyName,
                    style: createTextStyle(
                      fontFamily: fontFamilySemiBold,
                      height: 1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    data.address ?? "",
                    style: createTextStyle(
                      color: HouseColor.gray,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
