import 'package:house/importLib.dart';

class LandlordOrderListHome extends BaseStatefulWidget {
  final House data;

  LandlordOrderListHome(this.data);

  @override
  _LandlordOrderListHomeState createState() => _LandlordOrderListHomeState();
}

class _LandlordOrderListHomeState
    extends BaseAppBarAndBodyState<LandlordOrderListHome> {
  final GlobalKey<RefreshWidgetState> _refreshKey =
      GlobalKey<RefreshWidgetState>();
  final List<Order> _data = [];
  int _curPage = 1;

  @override
  void initState() {
    Future.delayed(Duration()).whenComplete(() {
      _refreshKey.currentState.show();
    });
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).orderList,
      ),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshWidget(
      key: _refreshKey,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index.isEven) {
                return _buildOrderItem(_data[index ~/ 2]);
              } else {
                return Container(
                  height: 1,
                  color: HouseColor.divider,
                );
              }
            },
            childCount: _data.length * 2,
          ),
        ),
      ],
      onRefresh: () async {
        await selectRepairOrderPageList(
          context,
          1,
          houseId: widget.data.id,
          cancelToken: cancelToken,
        ).then((data) {
          _data.clear();
          _data.addAll(data);
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
        await selectRepairOrderPageList(
          context,
          _curPage + 1,
          houseId: widget.data.id,
          cancelToken: cancelToken,
        ).then((data) {
          _data.addAll(data);
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

  Widget _buildOrderItem(Order data) {
    LogUtils.log(data.typeNames);
    return FlatButton(
      onPressed: () {
        push(context, OrderDetailHome(data.id));
      },
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: _build(data),
    );
  }

  Widget _build(Order data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          HouseValue.of(context).orderNo + data.orderNo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: createTextStyle(fontSize: 13),
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HouseCacheNetworkImage(
              DataUtils.getFirstImage(data.photos.content),
              width: 60,
              height: 60,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      children: _getSpan(data.typeNames, data.title),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      _getOrderStatus(data),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          data.address,
                          style: createTextStyle(
                            color: HouseColor.gray,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _getOrderStatus(Order data) {
    return Text(
      data.status.descEn,
      style: TextStyle(
        color: _getTextColor(data),
        fontSize: 15,
        fontFamily: "LatoSemibold",
      ),
    );
  }

  Color _getTextColor(Order data) {
    if (data.status.value == TypeStatus.orderFinished.value) {
      return HouseColor.green;
    } else if (data.status.value == TypeStatus.orderRejected.value) {
      return HouseColor.gray;
    } else {
      return HouseColor.red;
    }
  }

  List<TextSpan> _getSpan(String tags, String title) {
    List<TextSpan> a = tags.split(",").map((tag) {
      return TextSpan(
        text: "#$tag# ",
        style: createTextStyle(color: HouseColor.green),
      );
    }).toList();
    a.add(
      TextSpan(
        text: title,
        style: createTextStyle(),
      ),
    );
    return a;
  }
}
