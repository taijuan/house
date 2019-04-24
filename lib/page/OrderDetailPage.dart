import 'package:flutter/services.dart';
import 'package:house/importLib.dart';

class OrderDetailPage extends BaseStatefulWidget {
  final String id;
  final String repairQuoteId;

  OrderDetailPage(this.id, {this.repairQuoteId});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends BaseAppBarAndBodyState<OrderDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  TypeStatus _receiveUserType = TypeStatus.agent;
  OrderDetail _data;

  @override
  void initState() {
    if (Provide.value<ProviderUser>(context).isAgent()) {
      _receiveUserType = null;
    }
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).orderDetail,
      ),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Provide<ProviderOrderReLoad>(
      builder: (context, w, reload) => RefreshCustomScrollView(
          key: ValueKey(reload.reloadNum),
          slivers: _data == null
              ? []
              : [
                  _buildHouse(),
                  _buildLogs(),
                  _buildTitle(HouseValue.of(context).title),
                  _buildDescription(_data.repairOrder.title),
                  _buildTitle(HouseValue.of(context).description),
                  _buildDescription(_data.repairOrder.desc),
                  _buildTitle(HouseValue.of(context).type),
                  _buildTagList(),
                  _buildTitle(HouseValue.of(context).photos),
                  _buildPhotoList(),
                  _publishDateView,
                  _buildQuotationTitle(),
                  _buildQuotation(),
                  _buildRepairResultsViewTitle(),
                  _buildRepairResultsView(),
                  _buildRepairResultDescTitle(_data.repairOrder),
                  _buildRepairResultDesc(_data.repairOrder),
                  _buildMessageTitle(),
                  _buildMessage(),
                  _buildMessageList(),
                  SliverToBoxAdapter(child: Container(height: 12)),
                ],
          onRefresh: () async {
            await selectRepairOrderById(
              context,
              widget.id,
              widget.repairQuoteId,
              cancelToken: cancelToken,
            ).then((data) {
              this._data = data;
            }).catchError((e) {
              showToast(context, e.toString());
            }).whenComplete(() {
              setState(() {});
            });
          }),
    );
  }

  Widget _buildMessageTitle() {
    if (Provide.value<ProviderUser>(context).isVendor()) {
      return SliverToBoxAdapter();
    } else if (_data.repairOrder.status.value ==
        TypeStatus.orderFinished.value) {
      return SliverToBoxAdapter();
    } else if (_data.repairOrder.status.value ==
        TypeStatus.orderRejected.value) {
      return SliverToBoxAdapter();
    } else if (Provide.value<ProviderUser>(context).isAgent()) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.fromLTRB(12, 24, 12, 12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    HouseValue.of(context).leaveAMessage,
                    style: createTextStyle(),
                  ),
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  if (_receiveUserType != TypeStatus.tenant) {
                    _receiveUserType = TypeStatus.tenant;
                    setState(() {});
                  }
                },
                clipBehavior: Clip.antiAliasWithSaveLayer,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(
                  minWidth: 96,
                  minHeight: 30,
                  maxHeight: 30,
                ),
                padding: EdgeInsets.only(bottom: 2),
                fillColor: _receiveUserType == TypeStatus.tenant
                    ? HouseColor.black
                    : HouseColor.white,
                child: Text(
                  TypeStatus.userType[2].descEn,
                  style: _receiveUserType == TypeStatus.tenant
                      ? createTextStyle(color: HouseColor.white)
                      : createTextStyle(),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: HouseColor.black),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  if (_receiveUserType != TypeStatus.landlord) {
                    _receiveUserType = TypeStatus.landlord;
                    setState(() {});
                  }
                },
                clipBehavior: Clip.antiAliasWithSaveLayer,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(
                  minWidth: 96,
                  minHeight: 30,
                  maxHeight: 30,
                ),
                padding: EdgeInsets.only(bottom: 2),
                fillColor: _receiveUserType == TypeStatus.landlord
                    ? HouseColor.black
                    : HouseColor.white,
                child: Text(
                  TypeStatus.userType[1].descEn,
                  style: _receiveUserType == TypeStatus.landlord
                      ? createTextStyle(color: HouseColor.white)
                      : createTextStyle(),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: HouseColor.black),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else if (Provide.value<ProviderUser>(context).isLandlord()) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text(
            HouseValue.of(context).message,
            style: createTextStyle(
              fontSize: 17,
              fontFamily: fontFamilySemiBold,
            ),
          ),
        ),
      );
    } else if (Provide.value<ProviderUser>(context).isTenant()) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text(
            HouseValue.of(context).message,
            style: createTextStyle(
              fontSize: 17,
              fontFamily: fontFamilySemiBold,
            ),
          ),
        ),
      );
    } else {
      return SliverToBoxAdapter();
    }
  }

  Widget _buildMessage() {
    if (Provide.value<ProviderUser>(context).isVendor()) {
      return SliverToBoxAdapter();
    } else if (_data.repairOrder.status.value ==
        TypeStatus.orderFinished.value) {
      if (!DataUtils.isEmptyList(_data.repairMessages)) {
        return _buildTitle("Messages");
      }
      return SliverToBoxAdapter();
    } else if (_data.repairOrder.status.value ==
        TypeStatus.orderRejected.value) {
      if (!DataUtils.isEmptyList(_data.repairMessages)) {
        return _buildTitle("Messages");
      }
      return SliverToBoxAdapter();
    } else {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
          decoration: BoxDecoration(
            color: HouseColor.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: HouseColor.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: <Widget>[
                TextFormField(
                  enabled: true,
                  controller: _messageController,
                  decoration: InputDecoration(
                    enabled: true,
                    contentPadding: EdgeInsets.only(
                      left: 8,
                      top: 8,
                      right: 8,
                      bottom: 48,
                    ),
                    border: InputBorder.none,
                    hintText: _hintMessage,
                    hintStyle: createTextStyle(color: HouseColor.gray),
                  ),
                  textInputAction: TextInputAction.newline,
                  style: createTextStyle(),
                  maxLines: 4,
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: SizedBox(
                    height: 24,
                    child: OutlineButton(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
                      onPressed: () {
                        if (DataUtils.isEmpty(_messageController.text)) {
                          showToast(context, "input message");
                          return;
                        }
                        if (_receiveUserType == null) {
                          showToast(context, "select message to one");
                          return;
                        }
                        if (!DataUtils.isEmpty(_messageController.text)) {
                          showLoadingDialog(context);
                          saveRepairMessage(
                            context,
                            _data.repairOrder.id,
                            _messageController.text,
                            _getReceiveUserId(),
                            cancelToken: cancelToken,
                          ).then((v) {
                            pop(context);
                            _messageController.clear();
                            Provide.value<ProviderOrderReLoad>(context)
                                .reLoad();
                          }).catchError((e) {
                            pop(context);
                            showToast(context, e.toString());
                          });
                        }
                      },
                      child: Text(
                        _sendHintMessage,
                        style: createTextStyle(color: HouseColor.green),
                      ),
                      borderSide: BorderSide(color: HouseColor.green),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  String get _hintMessage {
    if (_receiveUserType == null) {
      return HouseValue.of(context).message;
    } else {
      return "${HouseValue.of(context).message} to ${_receiveUserType.descEn}";
    }
  }

  String get _sendHintMessage {
    if (_receiveUserType == null) {
      return HouseValue.of(context).send;
    } else {
      return "${HouseValue.of(context).send} to ${_receiveUserType.descEn}";
    }
  }

  String _getReceiveUserId() {
    if (_receiveUserType == TypeStatus.agent) {
      return _data.house.agencyId;
    } else if (_receiveUserType == TypeStatus.landlord) {
      return _data.house.landlordId;
    } else {
      return _data.house.tenantId;
    }
  }

  Widget _buildMessageList() {
    if (Provide.value<ProviderUser>(context).isVendor()) {
      return SliverToBoxAdapter();
    } else if (_data.repairMessages.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: HouseColor.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            "No messages(☄⊙ω⊙)☄",
            style: createTextStyle(
              color: HouseColor.green,
              fontSize: 17,
              fontFamily: fontFamilySemiBold,
            ),
          ),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isOdd) {
              Message data = _data.repairMessages[index ~/ 2];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: HouseColor.lightGray,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          Provide.value<ProviderUser>(context).userId ==
                                  data.sendUserId
                              ? "From ${HouseValue.of(context).me} to ${data.receiveUserType.descEn}"
                              : "From ${data.userType.descEn} to ${data.receiveUserType.descEn}",
                          style: createTextStyle(
                            fontFamily: fontFamilySemiBold,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            data.createTime,
                            style: createTextStyle(
                              color: HouseColor.gray,
                              fontSize: 13,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.message,
                      textAlign: TextAlign.start,
                      style: createTextStyle(fontSize: 13),
                    )
                  ],
                ),
              );
            } else {
              return SizedBox(height: 4);
            }
          },
          childCount: _data.repairMessages.length * 2,
        ),
      );
    }
  }

  @override
  Widget bottomNavigationBar(BuildContext context) {
    if (_data == null) {
      return SizedBox.shrink();
    } else if (Provide.value<ProviderUser>(context).isVendor() &&
        _data.repairQuote == null) {
      return _goToQuote();
    } else if (Provide.value<ProviderUser>(context).isVendor() &&
        _data.repairQuote.status.value == TypeStatus.repairProcessing.value) {
      return _goToVendorFinish();
    } else if (Provide.value<ProviderUser>(context).isVendor() &&
        _data.repairQuote.status.value == TypeStatus.repairConfirm.value) {
      return _goToVendorFinish();
    } else if (Provide.value<ProviderUser>(context).isAgent() &&
        _data.repairOrder.status.value == TypeStatus.orderSelecting.value) {
      return _chooseAVendorBtn();
    } else if (Provide.value<ProviderUser>(context).isLandlord() &&
        _data.repairOrder.status.value == TypeStatus.orderSelecting.value) {
      return _chooseAVendorBtn();
    } else if (Provide.value<ProviderUser>(context).isAgent() &&
        _data.repairOrder.status.value == TypeStatus.orderConfirming.value) {
      return closeAndFinishOrder();
    } else {
      return SizedBox.shrink();
    }
  }

  Container closeAndFinishOrder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: HouseColor.divider),
        ),
      ),
      height: 64,
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              color: HouseColor.lightGray,
              padding: EdgeInsets.only(bottom: 3),
              onPressed: () {
                showInputDialog(
                  context,
                  maxLength: 300,
                  maxLines: 6,
                  onOkPressed: (content) {
                    showLoadingDialog(context);
                    finishOrCloseRepairOrderStatus(
                      context,
                      _data.repairOrder.id,
                      5,
                      content,
                      cancelToken: cancelToken,
                    ).then((v) {
                      pop(context);
                      showToastSuccess(context);
                      Provide.value<ProviderOrderReLoad>(context).reLoad();
                    }).catchError((e) {
                      pop(context);
                      showToast(context, e.toString());
                    });
                  },
                );
              },
              child: Text(
                HouseValue.of(context).close,
                style: createTextStyle(),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: FlatButton(
              padding: EdgeInsets.only(bottom: 3),
              onPressed: () {
                showInputDialog(
                  context,
                  maxLength: 300,
                  maxLines: 6,
                  onOkPressed: (content) {
                    showLoadingDialog(context);
                    finishOrCloseRepairOrderStatus(
                      context,
                      _data.repairOrder.id,
                      4,
                      content,
                      cancelToken: cancelToken,
                    ).then((v) {
                      pop(context);
                      showToastSuccess(context);
                      Provide.value<ProviderOrderReLoad>(context).reLoad();
                    }).catchError((e) {
                      pop(context);
                      showToast(context, e.toString());
                    });
                  },
                );
              },
              color: HouseColor.green,
              child: Text(
                HouseValue.of(context).resolve,
                style: createTextStyle(color: HouseColor.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goToVendorFinish() {
    return Container(
      height: 48,
      color: HouseColor.green,
      child: FlatButton(
        onPressed: () {
          push(
            context,
            VendorRepairResults(
              _data.repairQuote.id,
              _data.repairQuote.repairOrderId,
            ),
          );
        },
        child: Text(
          HouseValue.of(context).submitRepairResults,
          style: createTextStyle(color: HouseColor.white),
        ),
      ),
    );
  }

  Widget _goToQuote() {
    return Container(
      height: 48,
      color: HouseColor.green,
      child: FlatButton(
        padding: EdgeInsets.only(bottom: 3),
        onPressed: () {
          push(
            context,
            VendorQuoteHome(
              _data.repairOrder.id,
            ),
          );
        },
        child: Text(
          HouseValue.of(context).quote,
          style: createTextStyle(color: HouseColor.white),
        ),
      ),
    );
  }

  Widget _chooseAVendorBtn() {
    return Container(
      height: 48,
      color: HouseColor.green,
      child: FlatButton(
        padding: EdgeInsets.only(bottom: 3),
        onPressed: () {
          push(
            context,
            QuotationListPage(
              _data.repairOrder,
            ),
          );
        },
        child: Text(
          HouseValue.of(context).chooseAVendor,
          style: createTextStyle(color: HouseColor.white),
        ),
      ),
    );
  }

  _buildHouse() {
    if (Provide.value<ProviderUser>(context).isVendor()) {
      return SliverToBoxAdapter(
        child: Container(
          width: 0,
          height: 1,
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, top: 12, right: 12),
      sliver: SliverToBoxAdapter(
        child: HouseCard(_data.house),
      ),
    );
  }

  Widget _buildLogs() {
    if (Provide.value<ProviderUser>(context).isAgent() ||
        Provide.value<ProviderUser>(context).isLandlord()) {
      List<OrderLogs> logs = [];
      int length = _data.repairOrderLogs.length;
      for (var i = 0; i < 5; i++) {
        OrderLogs a;
        if (length > i) {
          a = _data.repairOrderLogs[i];
          a.status = 1;
          logs.add(a);
        } else {
          a = OrderLogs.fromJson({});
          a.status = length == i ? 2 : 0;
          logs.add(a);
        }
        switch (i) {
          case 0:
            a.name = TypeStatus.agent.descEn;
            break;
          case 1:
            a.name = TypeStatus.vendor.descEn;
            break;
          case 2:
            a.name = "${TypeStatus.landlord.descEn}/${TypeStatus.agent.descEn}";
            break;
          case 3:
            a.name = TypeStatus.vendor.descEn;
            break;
          case 4:
            a.name = TypeStatus.agent.descEn;
            break;
        }
      }
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildOrderLogItem(0, logs),
              _buildOrderLogItem(1, logs),
              _buildOrderLogItem(2, logs),
              _buildOrderLogItem(3, logs),
              _buildOrderLogItem(4, logs),
            ],
          ),
        ),
      );
    } else {
      return SliverToBoxAdapter();
    }
  }

  Widget _buildOrderLogItem(int index, List<OrderLogs> logs) {
    var data = logs[index];
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomPaint(
            size: Size.fromHeight(32),
            painter: RepairLogIconPainter(
              isDrawLeft: index != 0,
              isDrawRight: index != 4,
              status: data.status,
            ),
          ),
          Container(height: 4),
          Text(
            data.name.toUpperCase(),
            style: createTextStyle(
              color: HouseColor.gray,
              fontSize: 8,
              height: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: createTextStyle(
              fontSize: 17, fontFamily: fontFamilyBold, height: 1),
        ),
      ),
    );
  }

  Widget _buildDescription(String des) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, right: 12),
      sliver: SliverToBoxAdapter(
        child: Text(
          des ?? "",
          style: createTextStyle(),
        ),
      ),
    );
  }

  Widget _buildPhotoList() {
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, right: 12, top: 4),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            String imageUrl = DataUtils.getImageUrl(
              _data.questionInfo.photos.content[index].picUrl,
            );
            return FlatButton(
              onPressed: () {
                push(
                  context,
                  ShowImage(
                    _data.questionInfo.photos.content,
                    startPos: index,
                  ),
                );
              },
              child: CacheImage(
                imageUrl,
              ),
            );
          },
          childCount: _data.questionInfo.photos.content.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
      ),
    );
  }

  get _publishDateView {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
      sliver: SliverToBoxAdapter(
        child: Text.rich(
          TextSpan(
            text: "${HouseValue.of(context).publishDate}：",
            style: createTextStyle(
              fontSize: 17,
              fontFamily: fontFamilyBold,
              height: 1,
            ),
            children: [
              TextSpan(
                text: _data.repairOrder.createTime,
                style: createTextStyle(
                  color: HouseColor.gray,
                  height: 1,
                  fontFamily: fontFamilyRegular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagList() {
    LogUtils.log("zuiweng   " + _data.repairOrder.typeNames);
    List<String> data = _data.repairOrder.typeNames.split(",");
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, right: 12, top: 4),
      sliver: SliverToBoxAdapter(
        child: Wrap(
          spacing: 12,
          alignment: WrapAlignment.start,
          runSpacing: 8,
          runAlignment: WrapAlignment.start,
          children: data.map((value) {
            return Container(
              decoration: BoxDecoration(
                color: HouseColor.green,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: Text(
                value,
                style: createTextStyle(color: HouseColor.white),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildQuotationTitle() {
    if (_data.repairQuote == null) {
      return SliverToBoxAdapter();
    } else {
      return _buildTitle("Maintenance quotation");
    }
  }

  Widget _buildQuotation() {
    if (_data.repairQuote == null) {
      return SliverToBoxAdapter();
    }

    if (Provide.value<ProviderUser>(context).isTenant()) {
      return SliverToBoxAdapter();
    }
    if (Provide.value<ProviderUser>(context).isVendor()) {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: HouseColor.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${_data.repairQuote.price} AUD",
                style: createTextStyle(
                  color: HouseColor.red,
                  fontFamily: fontFamilySemiBold,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                _data.repairQuote.desc,
                style: createTextStyle(),
              ),
            ],
          ),
        ),
      );
    } else {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
          decoration: BoxDecoration(
            color: HouseColor.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(12),
                height: 60,
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        push(
                          context,
                          VendorDetailHome(_data.repairQuote.userId),
                        );
                      },
                      child: CacheImage(
                        DataUtils.getImageUrl(_data.repairQuote.headImg),
                        width: 60,
                        height: 60,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _data.repairQuote.firstName ?? "",
                          style: createTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${_data.repairQuote.price} AUD",
                          style: createTextStyle(
                            color: HouseColor.red,
                            fontFamily: fontFamilySemiBold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: .5,
                color: HouseColor.divider,
              ),
              SizedBox(
                child: Container(
                  alignment: Alignment.centerRight,
                  height: 48,
                  padding: EdgeInsets.only(right: 12, top: 10, bottom: 12),
                  child: OutlineButton(
                    borderSide: BorderSide(color: HouseColor.gray, width: .5),
                    padding: EdgeInsets.only(bottom: 4, left: 12, right: 12),
                    onPressed: () {
                      showContentDialog(
                        context,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 8,
                          ),
                          child: Text(
                            _data.repairQuote.desc,
                            textAlign: TextAlign.start,
                            style: createTextStyle(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      HouseValue.of(context).detail,
                      style: createTextStyle(color: HouseColor.gray),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  _buildRepairResultsViewTitle() {
    if (DataUtils.isEmptyList(_data?.repairQuoteResults)) {
      return SliverToBoxAdapter();
    } else {
      return _buildTitle("Maintenance results from vendor");
    }
  }

  Widget _buildRepairResultsView() {
    if (DataUtils.isEmptyList(_data?.repairQuoteResults)) {
      return SliverToBoxAdapter();
    } else {
      var data = _data.repairQuoteResults;
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isOdd) {
              var a = data[index ~/ 2];
              return _buildRepairResultItem(a);
            } else {
              return Container(
                height: 8,
              );
            }
          },
          childCount: data.length * 2,
        ),
      );
    }
  }

  Container _buildRepairResultItem(RepairResult data) {
    return Container(
      decoration: BoxDecoration(
        color: HouseColor.lightGray,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            data.resultDesc,
            style: createTextStyle(height: 1, fontFamily: fontFamilySemiBold),
          ),
          Container(
            height: 12,
          ),
          GridView.builder(
            padding: EdgeInsets.only(),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              String imageUrl =
                  DataUtils.getImageUrl(data.image.content[index].picUrl);
              return FlatButton(
                onPressed: () {
                  push(
                    context,
                    ShowImage(
                      data.image.content,
                      startPos: index,
                    ),
                  );
                },
                child: CacheImage(
                  imageUrl,
                ),
              );
            },
            itemCount: data.image.content.length,
          ),
        ],
      ),
    );
  }

  _buildRepairResultDescTitle(Order data) {
    if (Provide.value<ProviderUser>(context).isTenant()) {
      return SliverToBoxAdapter();
    } else if (data.resultDesc.isEmpty) {
      return SliverToBoxAdapter();
    } else {
      return _buildTitle("Maintenance results confirmed by agency");
    }
  }

  _buildRepairResultDesc(Order data) {
    if (Provide.value<ProviderUser>(context).isTenant()) {
      return SliverToBoxAdapter();
    } else if (data.resultDesc.isEmpty) {
      return SliverToBoxAdapter();
    } else {
      return SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: HouseColor.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
          padding: EdgeInsets.all(12),
          child: Text(
            data.resultDesc,
            style: createTextStyle(height: 1, fontFamily: fontFamilySemiBold),
          ),
        ),
      );
    }
  }
}

class RepairLogIconPainter extends CustomPainter {
  final bool isDrawLeft, isDrawRight;
  final int status;
  final Paint dotPaint = Paint()
    ..color = HouseColor.green
    ..strokeWidth = 0
    ..isAntiAlias = true;

  final Paint dotHashPaint = Paint()
    ..color = HouseColor.lightGreen
    ..strokeWidth = 4
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true;

  final Paint linePaint = Paint()
    ..color = HouseColor.lightGray
    ..strokeWidth = 2
    ..isAntiAlias = true;

  final Paint whitePaint = Paint()
    ..color = HouseColor.white
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 2
    ..isAntiAlias = true;
  Path path = Path();

  RepairLogIconPainter({
    this.status,
    this.isDrawLeft,
    this.isDrawRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(
        isDrawLeft ? 0 : size.width / 2,
        size.height / 2,
      ),
      Offset(
        isDrawRight ? size.width : size.width / 2,
        size.height / 2,
      ),
      linePaint,
    );
    if (status == 1) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        6,
        dotPaint,
      );
    } else if (status == 2) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        6,
        dotPaint,
      );
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        3,
        linePaint,
      );
    } else {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        4,
        dotHashPaint,
      );
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        3,
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
