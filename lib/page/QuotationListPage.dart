import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';

class QuotationListPage extends BaseStatefulWidget {
  final Order data;

  QuotationListPage(this.data);

  @override
  _QuotationListPageState createState() => _QuotationListPageState();
}

class _QuotationListPageState
    extends BaseAppBarAndBodyState<QuotationListPage> {
  final List<Quotation> _data = [];
  String _transactor;
  final GlobalKey<RefreshWidgetState> _refreshKey =
      GlobalKey<RefreshWidgetState>();
  int _currentPage = 0;

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
      decoration: BoxDecoration(color: HouseColor.white),
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).taskList,
      ),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshWidget(
      key: _refreshKey,
      slivers: <Widget>[
        _buildAuthBtn(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index.isEven) {
                return _buildItem(_data[index ~/ 2]);
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
        await selectRepairQuotePageList(
          context,
          widget.data.id,
          1,
          cancelToken: cancelToken,
        ).then((data) {
          this._data.clear();
          this._data.addAll(data.data);
          this._transactor = data.transactor;
          if (_data.length >= 10) {
            _refreshKey.currentState.more();
          } else if(DataUtils.isEmptyList(_data)) {
            _refreshKey.currentState.refreshNoData();
          }else{
            _refreshKey.currentState.loadMoreNoData();
          }
          _currentPage = 1;
          setState(() {});
        }).catchError((e) {
          showToast(context, e.toString());
        });
      },
      onLoadMore: () async {
        await selectRepairQuotePageList(
          context,
          widget.data.id,
          _currentPage + 1,
          cancelToken: cancelToken,
        ).then((data) {
          this._data.addAll(data.data);
          this._transactor = data.transactor;
          if (_data.length >= 10) {
            _refreshKey.currentState.more();
          } else {
            _refreshKey.currentState.loadMoreNoData();
          }
          _currentPage++;
          setState(() {});
        }).catchError((e) {
          showToast(context, e.toString());
        });
      },
    );
  }

  Widget _buildAuthBtn() {
    User user = User.getUserSync();
    LogUtils.log("_transactor${_transactor ?? ""}");
    if (this._transactor == null) {
      return SliverToBoxAdapter();
    } else if (user.type.value == TypeStatus.agent.value && !_isAuth()) {
      return SliverToBoxAdapter(
        child: Container(
          color: HouseColor.lightGreen,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(bottom: 12),
          child: Text(
            HouseValue.of(context).authProcessing,
            style: createTextStyle(color: HouseColor.green),
          ),
        ),
      );
    } else if (user.type.value == TypeStatus.landlord.value) {
      return SliverPadding(
        padding: EdgeInsets.all(12),
        sliver: SliverToBoxAdapter(
          child: FlatButton(
            onPressed: _isAuth() ? null : _showAuthDialog,
            padding: EdgeInsets.symmetric(horizontal: 12),
            color: HouseColor.white,
            disabledColor: HouseColor.white,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    HouseValue.of(context).authorizedAgency,
                    style: createTextStyle(fontFamily: fontFamilySemiBold),
                  ),
                ),
                Spacer(),
                _isAuth()
                    ? Icon(
                        HouseIcons.checkOkIcon,
                        color: HouseColor.green,
                        size: 20,
                      )
                    : Icon(
                        HouseIcons.unCheckIcon,
                        color: HouseColor.gray,
                        size: 20,
                      ),
              ],
            ),
          ),
        ),
      );
    } else {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 12,
        ),
      );
    }
  }

  void _showAuthDialog() async {
    await showAlertDialog(
      context,
      content: HouseValue.of(context).authNotice,
      onOkPressed: () async {
        showLoadingDialog(context);
        await authorizedAgentsRepairOrder(
          context,
          widget.data.id,
          cancelToken: cancelToken,
        ).then((value) {
          pop(context);
          pop(context);
        }).catchError((e) {
          pop(context);
          showToast(context, e.toString());
        });
      },
    );
  }

  Widget _buildItem(Quotation data) {
    return Card(
      color: HouseColor.white,
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(12),
            height: 84,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    push(context, VendorDetailHome(data.userId));
                  },
                  child: HouseCacheNetworkImage(
                    DataUtils.getImageUrl(data.headImg),
                    width: 60,
                    height: 60,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        data.firstName,
                        style: createTextStyle(),
                      ),
                      Text(
                        data.price.toStringAsFixed(2) + " AUD",
                        style: TextStyle(
                          color: HouseColor.red,
                          fontSize: 17,
                          fontFamily: "LatoSemiBold",
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: HouseColor.divider,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 28,
                margin: EdgeInsets.symmetric(vertical: 12),
                child: OutlineButton(
                  padding:EdgeInsets.symmetric(horizontal: 8),
                  onPressed: () {
                    _showDetailDialog(data);
                  },
                  borderSide: BorderSide(color: HouseColor.divider),
                  highlightedBorderColor: HouseColor.divider,
                  child: Text(
                    HouseValue.of(context).detail,
                    style: createTextStyle(
                        fontFamily: fontFamilySemiBold, height: 1),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                height: 28,
                child: OutlineButton(
                  padding:EdgeInsets.symmetric(horizontal: 8),
                  borderSide: BorderSide(color: HouseColor.green),
                  highlightedBorderColor: HouseColor.green,
                  disabledBorderColor: HouseColor.divider,
                  disabledTextColor: HouseColor.divider,
                  onPressed: _isAuth()
                      ? null
                      : () {
                          _showChooseAVendorDialog(data);
                        },
                  child: Text(
                    HouseValue.of(context).accept,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(Quotation data) async {
    await showContentDialog(
      context,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text(
          data.desc,
          textAlign: TextAlign.center,
          style: createTextStyle(),
        ),
      ),
    );
  }

  void _showChooseAVendorDialog(Quotation data) async {
    await showAlertDialog(
      context,
      content: HouseValue.of(context)
          .areYouSureToChoose
          .replaceAll("#", data.firstName ?? ""),
      onOkPressed: () {
        _repairOrderDesignateQuote(data);
      },
    );
  }

  void _repairOrderDesignateQuote(Quotation data) async {
    showLoadingDialog(context);
    await repairOrderDesignateQuote(
      context,
      data.id,
      widget.data.id,
      cancelToken: cancelToken,
    ).then((value) {
      pop(context);
      pop(context);
    }).catchError((e) {
      pop(context);
      showToast(context, e.toString());
    });
  }

  bool _isAuth() {
    return User.getUserSync().id != this._transactor;
  }
}
