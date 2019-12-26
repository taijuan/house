import 'package:house/importLib.dart';

class LandlordOrdersPage extends BaseStatefulWidget {
  final House data;
  final int status;

  LandlordOrdersPage({
    this.data,
    this.status,
  });

  @override
  _LandlordOrdersPageState createState() => _LandlordOrdersPageState();
}

class _LandlordOrdersPageState
    extends BaseAppBarAndBodyState<LandlordOrdersPage> {
//  final GlobalKey<RefreshWidgetState> _refreshKey =
//      GlobalKey<RefreshWidgetState>();
  final List<Order> _data = [];

//  int _curPage = 1;

//  @override
//  void initState() {
//    Future.delayed(Duration()).whenComplete(() {
//      _refreshKey.currentState.show();
//    });
//    super.initState();
//  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).orders,
      ),
      navigatorBack:
          widget.data == null ? null : TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Provide<ProviderOrderReLoad>(
      builder: (_, a, reload) => RefreshListView(
            key: ValueKey(reload.reloadNum),
            itemBuilder: (context, index) => _buildOrderItem(_data[index]),
            separatorBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: .5,
                  color: HouseColor.divider,
                ),
            itemCount: _data.length,
            onRefresh: () async {
              await selectRepairOrderPageList(
                context,
                1,
                houseId: widget.data?.id,
                status: widget.status,
                cancelToken: cancelToken,
              ).then((data) {
                _data.clear();
                _data.addAll(data);
              }).catchError((e) {
                showMsgToast(context, e.toString());
              }).whenComplete(() {
                setState(() {});
              });
            },
            onLoadMore: (page) async {
              await selectRepairOrderPageList(
                context,
                page,
                houseId: widget.data?.id,
                cancelToken: cancelToken,
              ).then((data) {
                _data.addAll(data);
              }).catchError((e) {
                showMsgToast(context, e.toString());
              }).whenComplete(() {
                setState(() {});
              });
            },
          ),
    );
  }

  Widget _buildOrderItem(Order data) {
    LogUtils.log(data.typeNames);
    return FlatButton(
      onPressed: () {
        push(
          context,
          OrderDetailPage(data.id),
        )..then((isRefresh) {
            if (isRefresh == true) {
//              _refreshKey.currentState.show();
            }
          });
      },
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: _build(data),
    );
  }

  Widget _build(Order data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(
              HouseValue.of(context).orderNo + data.orderNo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: createTextStyle(
                fontSize: 13,
                height: 1,
              ),
            ),
            Expanded(
              child: Text(
                data.createTime,
                maxLines: 1,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: createTextStyle(
                  fontSize: 13,
                  color: HouseColor.gray,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CacheImage(
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
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      children: _getSpan(data.typeNames, data.title),
                      style: createTextStyle(height: 1),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  _getOrderStatus(data),
                  Text(
                    data.address,
                    style: createTextStyle(
                      color: HouseColor.gray,
                      fontSize: 13,
                      height: 1,
                    ),
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

  Widget _getOrderStatus(Order data) {
    return Text(
      data.status.descEn.toUpperCase(),
      maxLines: 1,
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: _getTextColor(data),
        fontSize: 14,
        fontFamily: "LatoSemibold",
        height: 1,
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
        style: createTextStyle(
          color: HouseColor.green,
          height: 1,
        ),
      );
    }).toList();
    a.add(
      TextSpan(
        text: title,
        style: createTextStyle(
          height: 1,
        ),
      ),
    );
    return a;
  }

  @override
  bool get wantKeepAlive => true;
}
