import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';

class OrdersHome extends BaseStatefulWidget {
  final int status;

  /// "1,2,3"
  final String queryStatus;

  OrdersHome({
    this.status,
    this.queryStatus,
  }) : super(key: ValueKey(status));

  @override
  _OrdersHomeState createState() => _OrdersHomeState();
}

class _OrdersHomeState extends BaseState<OrdersHome>
    with AutomaticKeepAliveClientMixin<OrdersHome> {
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
  Widget build(BuildContext context) {
    return RefreshWidget(
      key: _refreshKey,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index.isEven) {
                return _buildOrderItem(_data[index ~/ 2]);
              } else {
                return Container(
                  height: .5,
                  margin: EdgeInsets.symmetric(horizontal: 12),
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
          status: widget.status,
          queryStatus: widget.queryStatus,
          cancelToken: cancelToken,
        ).then((data) {
          _data.clear();
          _data.addAll(data);
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
        await selectRepairOrderPageList(
          context,
          _curPage + 1,
          status: widget.status,
          queryStatus: widget.queryStatus,
          cancelToken: cancelToken,
        ).then((data) {
          _data.addAll(data);
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

  Widget _buildOrderItem(Order data) {
    return FlatButton(
      onPressed: () {
        push(
          context,
          OrderDetailPage(
            data.id,
            repairQuoteId: data.repairQuoteId,
          ),
        )..then((isRefresh) {
            if (isRefresh == true) {
              _refreshKey.currentState.show();
            }
          });
      },
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: _build(data),
    );
  }

  Widget _build(Order data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              HouseValue.of(context).orderNo + data.orderNo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: createTextStyle(fontSize: 13, height: 1),
              textAlign: TextAlign.start,
            ),
            Expanded(
              child: Text(
                data.createTime,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: createTextStyle(
                  fontSize: 12,
                  height: 1,
                  color: HouseColor.gray,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HouseCacheNetworkImage(
              DataUtils.getFirstImage(data.photos.content),
              width: 80,
              height: 80,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _getRepairStatus(data),
                  Text.rich(
                    TextSpan(
                        children: _getSpan(data.typeNames, data.title),
                        style: createTextStyle(height: 1)),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    data.address,
                    style:
                        createTextStyle(color: HouseColor.gray, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _getRepairStatus(Order data) {
    if (data.repairQuoteStatus.descEn == null) {
      return Container(width: 0, height: 0);
    }
    return Text(
      data.repairQuoteStatus.descEn,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: _getTextColor(data),
        fontSize: 15,
        fontFamily: "LatoSemibold",
        height: 1,
      ),
    );
  }

  Color _getTextColor(Order data) {
    if (data.repairQuoteStatus.value == TypeStatus.repairFinished.value) {
      return HouseColor.green;
    } else if (data.repairQuoteStatus.value ==
        TypeStatus.repairProcessing.value) {
      return HouseColor.green;
    } else if (data.repairQuoteStatus.value ==
        TypeStatus.repairRejected.value) {
      return HouseColor.gray;
    } else {
      return HouseColor.red;
    }
  }

  List<TextSpan> _getSpan(String tags, String title) {
    List<TextSpan> a = tags.split(",").map((tag) {
      return TextSpan(
        text: "#$tag# ",
        style: createTextStyle(
          color: HouseColor.green,
          height: 1,
          fontFamily: fontFamilySemiBold,
        ),
      );
    }).toList();
    a.add(
      TextSpan(
        text: title,
        style: createTextStyle(
          fontFamily: fontFamilySemiBold,
          height: 1,
        ),
      ),
    );
    return a;
  }
}
