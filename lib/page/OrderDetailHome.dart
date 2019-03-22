import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:house/importLib.dart';

class OrderDetailHome extends BaseStatefulWidget {
  final String id;
  final String repairQuoteId;

  OrderDetailHome(this.id, {this.repairQuoteId});

  @override
  _OrderDetailHomeState createState() => _OrderDetailHomeState();
}

class _OrderDetailHomeState extends BaseAppBarAndBodyState<OrderDetailHome> {
  final GlobalKey<RefreshIndicatorState> _globalKey =
      GlobalKey<RefreshIndicatorState>();
  ui.Image image;

  final TextEditingController _messageController = TextEditingController();
  int _receiveUserType = TypeStatus.agency.value;
  OrderDetail _data;

  Future<ui.Image> _getImage() async {
    ByteData data = await rootBundle.load("image/3.0x/house_timeline.webp");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  void initState() {
    if (User.getUserSync().type.value == TypeStatus.agency.value) {
      _receiveUserType = TypeStatus.tenant.value;
    }
    Future.delayed(Duration()).whenComplete(() {
      _globalKey.currentState.show();
    });
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
    return RefreshIndicator(
        key: _globalKey,
        semanticsLabel: "",
        child: CustomScrollView(
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
                  _buildTitle(HouseValue.of(context).photo),
                  _buildPhotoList(),
                  _data.repairQuote == null
                      ? SliverToBoxAdapter()
                      : _buildTitle(
                          TypeStatus.userType[3].descEn,
                        ),
                  _buildQuotation(),
                  _vendorResultStatus(),
                  _vendorResultDesc(),
                  _vendorResultPhotos(),
                  _buildMessageTitle(),
                  _buildMessage(),
                  _buildMessageList(),
                ],
        ),
        onRefresh: () async {
          image = await _getImage();
          await selectRepairOrderById(
            context,
            widget.id,
            widget.repairQuoteId,
            cancelToken: cancelToken,
          ).then((data) {
            this._data = data;
            setState(() {});
          }).catchError((e) {
            showToast(context, e.toString());
          });
        });
  }

  Widget _buildMessageTitle() {
    int userType = User.getUserSync().type.value;
    if (userType == TypeStatus.agency.value) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
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
                  if (_receiveUserType != TypeStatus.tenant.value) {
                    _receiveUserType = TypeStatus.tenant.value;
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
                fillColor: _receiveUserType == TypeStatus.tenant.value
                    ? HouseColor.black
                    : HouseColor.white,
                child: Text(
                  TypeStatus.userType[2].descEn,
                  style: _receiveUserType == TypeStatus.tenant.value
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
                  if (_receiveUserType != TypeStatus.landlord.value) {
                    _receiveUserType = TypeStatus.landlord.value;
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
                fillColor: _receiveUserType == TypeStatus.landlord.value
                    ? HouseColor.black
                    : HouseColor.white,
                child: Text(
                  TypeStatus.userType[1].descEn,
                  style: _receiveUserType == TypeStatus.landlord.value
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
    } else if (userType == TypeStatus.landlord.value) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            HouseValue.of(context).message,
            style: createTextStyle(
              fontSize: 17,
              fontFamily: fontFamilySemiBold,
            ),
          ),
        ),
      );
    } else if (userType == TypeStatus.tenant.value) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
    if (User.getUserSync().type.value == TypeStatus.userType[3].value) {
      return SliverToBoxAdapter();
    } else if (_data.repairOrder.status.value ==
        TypeStatus.orderStatus[4].value) {
      return SliverToBoxAdapter();
    } else if (_data.repairOrder.status.value ==
        TypeStatus.orderStatus[5].value) {
      return SliverToBoxAdapter();
    } else {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
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
                    hintText: HouseValue.of(context).message,
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
                      onPressed: () async {
                        if (!DataUtils.isEmpty(_messageController.text)) {
                          showLoadingDialog(context);
                          await saveRepairMessage(
                            context,
                            _data.repairOrder.id,
                            _messageController.text,
                            _getReceiveUserId(),
                            cancelToken: cancelToken,
                          ).then((v) {
                            pop(context);
                            _messageController.clear();
                            _globalKey.currentState.show();
                          }).catchError((e) {
                            pop(context);
                            showToast(context, e.toString());
                          });
                        }
                      },
                      child: Text(
                        HouseValue.of(context).send,
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

  String _getReceiveUserId() {
    if (_receiveUserType == TypeStatus.userType[0].value) {
      return _data.house.agencyId;
    } else if (_receiveUserType == TypeStatus.userType[1].value) {
      return _data.house.landlordId;
    } else {
      return _data.house.tenantId;
    }
  }

  Widget _buildMessageList() {
    if (User.getUserSync().type.value == TypeStatus.userType[3].value) {
      return SliverToBoxAdapter();
    } else if (_data.repairMessages.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
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
            if (index.isEven) {
              Message data = _data.repairMessages[index ~/ 2];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
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
                          User.getUserSync().id == data.sendUserId
                              ? HouseValue.of(context).me
                              : data.userType.descEn,
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
    int userType = User.getUserSync().type.value;
    if (_data == null) {
      return SizedBox.shrink();
    } else if (userType == TypeStatus.vendor.value &&
        _data.repairQuote == null) {
      return _goToQuote();
    } else if (userType == TypeStatus.vendor.value &&
        _data.repairQuote.status.value == TypeStatus.repairProcessing.value) {
      return _goToVendorFinish();
    } else if (userType == TypeStatus.agency.value &&
        _data.repairOrder.status.value == TypeStatus.orderSelecting.value) {
      return _chooseAVendorBtn();
    } else if (userType == TypeStatus.landlord.value &&
        _data.repairOrder.status.value == TypeStatus.orderSelecting.value) {
      return _chooseAVendorBtn();
    } else if (userType == TypeStatus.agency.value &&
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
              onPressed: () async {
                await showAlertDialog(
                  context,
                  content: HouseValue.of(context).areYouOk.replaceAll(
                        "#",
                        HouseValue.of(context).close,
                      ),
                  onOkPressed: () async {
                    showLoadingDialog(context);
                    await finishOrCloseRepairOrderStatus(
                      context,
                      _data.repairOrder.id,
                      5,
                      cancelToken: cancelToken,
                    ).then((v) {
                      pop(context);
                      pop(context);
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
              onPressed: () async {
                showAlertDialog(
                  context,
                  content: HouseValue.of(context).areYouOk.replaceAll(
                        "#",
                        HouseValue.of(context).finished,
                      ),
                  onOkPressed: () async {
                    showLoadingDialog(context);
                    await finishOrCloseRepairOrderStatus(
                      context,
                      _data.repairOrder.id,
                      4,
                      cancelToken: cancelToken,
                    ).then((v) {
                      pop(context);
                      pop(context);
                    }).catchError((e) {
                      pop(context);
                      showToast(context, e.toString());
                    });
                  },
                );
              },
              color: HouseColor.green,
              child: Text(
                HouseValue.of(context).finished,
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
        onPressed: () async {
          await pushReplacement(
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
        onPressed: () async {
          await pushReplacement(
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
        onPressed: () async {
          await pushReplacement(
            context,
            QuotationListHome(
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

  SliverPadding _buildHouse() {
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, top: 12, right: 12),
      sliver: SliverToBoxAdapter(
        child: HouseCard(_data.house),
      ),
    );
  }

  Widget _buildLogs() {
    if (User.getUserSync().type.value == TypeStatus.agency.value ||
        User.getUserSync().type.value == TypeStatus.landlord.value) {
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
            a.name = TypeStatus.agency.descEn;
            break;
          case 1:
            a.name = TypeStatus.vendor.descEn;
            break;
          case 2:
            a.name =
                "${TypeStatus.landlord.descEn}/${TypeStatus.agency.descEn}";
            break;
          case 3:
            a.name = TypeStatus.vendor.descEn;
            break;
          case 4:
            a.name = TypeStatus.agency.descEn;
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
              image: image,
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
            fontSize: 17,
            fontFamily: fontFamilySemiBold,
          ),
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
              child: HouseCacheNetworkImage(
                imageUrl,
                aspectRatio: 1,
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

  Widget _buildTagList() {
    LogUtils.log("zuiweng   " + _data.repairOrder.typeNames);
    List<String> data = _data.repairOrder.typeNames.split(",");
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, right: 12, top: 4),
      sliver: SliverToBoxAdapter(
        child: Wrap(
          spacing: 12,
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

  Widget _buildQuotation() {
    if (_data.repairQuote == null) {
      return SliverToBoxAdapter();
    }
    int userType = User.getUserSync().type.value;
    if (userType == TypeStatus.tenant.value) {
      return SliverToBoxAdapter();
    }
    if (userType == TypeStatus.landlord.value) {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          padding: EdgeInsets.all(12),
          color: HouseColor.lightGray,
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
          margin: EdgeInsets.symmetric(horizontal: 12),
          color: HouseColor.lightGray,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(12),
                height: 60,
                child: Row(
                  children: <Widget>[
                    HouseCacheNetworkImage(
                      DataUtils.getImageUrl(_data.repairQuote.headImg),
                      width: 60,
                      height: 60,
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
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            _data.repairQuote.desc,
                            textAlign: TextAlign.center,
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

  Widget _vendorResultStatus() {
    int status = _data.repairQuote?.resultStatus ?? 0;
    if (status == 0) {
      return SliverToBoxAdapter();
    } else {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 12, top: 12, right: 12),
          padding: EdgeInsets.all(12),
          color: HouseColor.lightGray,
          child: Text.rich(
            TextSpan(
              text: HouseValue.of(context).repairResults + ": ",
              style: createTextStyle(
                fontSize: 17,
                fontFamily: fontFamilySemiBold,
              ),
              children: [
                TextSpan(
                  text: status == 1
                      ? HouseValue.of(context).finished
                      : HouseValue.of(context).unFinished,
                  style: createTextStyle(
                    color: status == 1 ? HouseColor.green : HouseColor.red,
                    fontSize: 17,
                    fontFamily: fontFamilySemiBold,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _vendorResultDesc() {
    int status = _data.repairQuote?.resultStatus ?? 0;
    if (status == 0) {
      return SliverToBoxAdapter();
    }
    String desc = _data.repairQuote?.resultDesc ?? "";
    if (DataUtils.isEmpty(desc)) {
      return SliverToBoxAdapter();
    } else {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          padding: EdgeInsets.symmetric(horizontal: 12),
          color: HouseColor.lightGray,
          child: Text(
            desc,
            style: createTextStyle(),
          ),
        ),
      );
    }
  }

  Widget _vendorResultPhotos() {
    if (DataUtils.isEmptyList(_data?.repairQuote?.photos?.content)) {
      return SliverToBoxAdapter();
    } else {
      return SliverToBoxAdapter(
        child: Container(
          color: HouseColor.lightGray,
          margin: EdgeInsets.symmetric(horizontal: 12),
          padding: EdgeInsets.all(12),
          child: GridView.builder(
            padding: EdgeInsets.only(),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              String imageUrl = DataUtils.getImageUrl(
                  _data.repairQuote.photos.content[index].picUrl);
              return FlatButton(
                onPressed: () {
                  push(
                    context,
                    ShowImage(
                      _data.repairQuote.photos.content,
                      startPos: index,
                    ),
                  );
                },
                child: HouseCacheNetworkImage(
                  imageUrl,
                  aspectRatio: 1,
                ),
              );
            },
            itemCount: _data.repairQuote.photos.content.length,
          ),
        ),
      );
    }
  }
}

class RepairLogIconPainter extends CustomPainter {
  final ui.Image image;
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
    this.image,
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
    } else if (status == 2 && image != null) {
      double scale = 1;
      double dw = size.width / image.width;
      double dh = size.height / image.height;
      scale = dw <= dh ? dw : dh;
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(
          0,
          0,
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        Rect.fromLTWH(
          size.width / 2 - image.width * scale / 2,
          size.height / 2 - image.height * scale / 2,
          image.width * scale,
          image.height * scale,
        ),
        dotPaint,
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
