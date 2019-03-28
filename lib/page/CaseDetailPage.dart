import 'package:house/importLib.dart';

class CaseDetailPage extends BaseStatefulWidget {
  final Question data;

  CaseDetailPage(this.data);

  @override
  _CaseDetailPageState createState() {
    return _CaseDetailPageState();
  }
}

class _CaseDetailPageState extends BaseAppBarAndBodyState<CaseDetailPage> {
  final GlobalKey<RefreshIndicatorState> _globalKey =
      GlobalKey<RefreshIndicatorState>();
  bool isRefresh = false;
  QuestionDetail _data;

  @override
  void initState() {
    Future.delayed(Duration()).whenComplete(() {
      _globalKey.currentState.show();
    });
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      navigatorBack: TitleAppBar.navigatorBackBlack(
        context,
        onPressed: () {
          pop(context, result: isRefresh);
        },
        willPop: true,
      ),
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).taskDescription,
      ),
    );
  }

  @override
  Widget bottomNavigationBar(BuildContext context) {
    int type = User.getUserSync().type.value;
    int status = _data?.questionInfo?.status?.value ?? -1;
    if (_data == null) {
      return SizedBox.shrink();
    } else if (status == TypeStatus.questionStatus[3].value) {
      return SizedBox.shrink();
    } else if (status == TypeStatus.questionStatus[2].value) {
      return SizedBox.shrink();
    } else if (type == TypeStatus.userType[0].value) {
      if (DataUtils.isEmptyList(_data.repairOrders)) {
        return _byPass();
      } else {
        return _publishAndFinish();
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _publishAndFinish() {
    return Container(
      height: 48,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: HouseColor.divider,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: OutlineButton(
              borderSide: BorderSide(color: HouseColor.green),
              onPressed: () {
                push(
                  context,
                  PublishOrderHome(widget.data.id),
                ).then((isRefresh) {
                  if (isRefresh) {
                    this.isRefresh = isRefresh;
                    setState(() {
                      _globalKey.currentState.show();
                    });
                  }
                });
              },
              child: Text(
                "+",
                style: createTextStyle(),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: FlatButton(
              color: HouseColor.green,
              disabledColor: HouseColor.divider,
              onPressed: _isAllFinishOrClose() ? _showConformDialog : null,
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

  _showConformDialog() {
    showAlertDialog(
      context,
      content: HouseValue.of(context).areYouOk.replaceAll(
            "#",
            "finish this case",
          ),
      onOkPressed: () {
        showLoadingDialog(context);
        finishOrRejectQuestionInfoStatus(
          context,
          _data.questionInfo.id,
          2,
          cancelToken: cancelToken,
        ).then((v) {
          pop(context);
          showToastSuccess(context);
          this.isRefresh = true;
          _globalKey.currentState.show();
        }).catchError((e) {
          pop(context);
          showToast(context, e.toString());
        });
      },
    );
  }

  Widget _byPass() {
    return Container(
      height: 48,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: HouseColor.divider,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: FlatButton(
              color: HouseColor.divider,
              onPressed: () async {
                showLoadingDialog(context);
                await finishOrRejectQuestionInfoStatus(
                  context,
                  _data.questionInfo.id,
                  3,
                  cancelToken: cancelToken,
                ).then((v) {
                  pop(context);
                  showToastSuccess(context);
                  this.isRefresh = true;
                  _globalKey.currentState.show();
                }).catchError((e) {
                  pop(context);
                  showToast(context, e.toString());
                });
              },
              child: Text(
                HouseValue.of(context).byPass,
                style: createTextStyle(),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: FlatButton(
              color: HouseColor.green,
              onPressed: () {
                push(
                  context,
                  PublishOrderHome(widget.data.id),
                ).then((isRefresh) {
                  if (isRefresh) {
                    this.isRefresh = isRefresh;
                    setState(() {
                      _globalKey.currentState.show();
                    });
                  }
                });
              },
              child: Text(
                HouseValue.of(context).publish,
                style: createTextStyle(color: HouseColor.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isAllFinishOrClose() {
    bool a = _data.repairOrders.every((v) {
      int status = v.status.value;
      return status == 4 || status == 5;
    });
    return a;
  }

  @override
  Widget body(BuildContext context) {
    return RefreshIndicator(
      key: _globalKey,
      semanticsLabel: "",
      onRefresh: () async {
        await selectQuestionDetail(
          context,
          widget.data.id,
          cancelToken: cancelToken,
        ).then((data) {
          _data = data;
          setState(() {});
        }).catchError((e) {
          showToast(context, e.toString());
        });
      },
      child: CustomScrollView(
        slivers: <Widget>[
          _buildHouse(),
          DataUtils.isEmptyList(_data?.repairOrders)
              ? SliverToBoxAdapter()
              : _buildTitle(HouseValue.of(context).orders),
          _buildOrders(),
          _buildTitle(HouseValue.of(context).description),
          _buildDescription(),
          _buildTitle(HouseValue.of(context).photo),
          _buildPhotoList(),
          SliverToBoxAdapter(
            child: Container(
              height: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouse() {
    if (_data == null) {
      return SliverToBoxAdapter();
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
        sliver: SliverToBoxAdapter(
          child: HouseCard(_data.house),
        ),
      );
    }
  }

  Widget _buildTitle(String title) {
    if (_data == null) {
      return SliverToBoxAdapter();
    } else {
      return SliverPadding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
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
  }

  Widget _buildDescription() {
    if (_data == null) {
      return SliverToBoxAdapter();
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 12, right: 12),
        sliver: SliverToBoxAdapter(
          child: Text(
            _data.questionInfo.description ?? "",
            style: createTextStyle(),
          ),
        ),
      );
    }
  }

  Widget _buildPhotoList() {
    if (_data == null) {
      return SliverToBoxAdapter();
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(left: 12, right: 12),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              String imageUrl = DataUtils.getImageUrl(
                  _data.questionInfo.photos.content[index].picUrl);
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
  }

  Widget _buildOrders() {
    if (DataUtils.isEmptyList(_data?.repairOrders)) {
      return SliverToBoxAdapter();
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isEven) {
              return _buildOrderItem(_data.repairOrders[index ~/ 2]);
            } else {
              return SizedBox(
                height: (index + 1 == _data.repairOrders.length * 2) ? 0 : 8,
              );
            }
          },
          childCount: _data.repairOrders.length * 2,
        ),
      );
    }
  }

  Widget _buildOrderItem(Order data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          MaterialButton(
            padding: EdgeInsets.fromLTRB(8, 8, 48, 12),
            onPressed: () {
              push(
                context,
                OrderDetailHome(data.id),
              )..then((isRefresh) {
                  if (isRefresh == true) {
                    this.isRefresh = true;
                    _globalKey.currentState.show();
                  }
                });
            },
            color: _getBgColor(data),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  HouseValue.of(context).orderNo + data.orderNo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: createTextStyle(fontSize: 13),
                ),
                SizedBox(height: 8, width: double.infinity),
                Text(
                  data.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _getTextColor(data),
                    fontSize: 15,
                    fontFamily: "LatoSemibold",
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            width: 48,
            height: 48,
            child: _getOrderStatus(data),
          )
        ],
      ),
    );
  }

  Widget _getOrderStatus(Order data) {
    if (data.status.value == TypeStatus.orderFinished.value) {
      return Icon(
        HouseIcons.rightIcon,
        color: HouseColor.green,
      );
    } else if (data.status.value == TypeStatus.orderRejected.value) {
      return Icon(
        HouseIcons.wrongIcon,
        color: HouseColor.red,
      );
    } else if (data.status.value == TypeStatus.orderWaiting.value ||
        data.status.value == TypeStatus.orderSelecting.value) {
      return FlatButton(
        onPressed: () {
          if (User.getUserSync().type.value != TypeStatus.agency.value) {
            return;
          }
          showAlertDialog(
            context,
            content:
                HouseValue.of(context).areYouSureToDeleteThisOrder.replaceAll(
                      "#",
                      data.title,
                    ),
            onOkPressed: () {
              _deleteRepairOrderById(data);
            },
          );
        },
        child: Icon(
          HouseIcons.deleteIcon,
          color: HouseColor.gray,
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Color _getBgColor(Order data) {
    if (data.status.value == TypeStatus.orderFinished.value) {
      return HouseColor.lightGreen;
    } else if (data.status.value == TypeStatus.orderRejected.value) {
      return HouseColor.lightRed;
    } else {
      return HouseColor.lightYellow;
    }
  }

  Color _getTextColor(Order data) {
    if (data.status.value == TypeStatus.orderFinished.value) {
      return HouseColor.green;
    } else if (data.status.value == TypeStatus.orderRejected.value) {
      return HouseColor.red;
    } else {
      return HouseColor.yellow;
    }
  }

  _deleteRepairOrderById(Order data) {
    showLoadingDialog(context);
    deleteRepairOrderById(
      context: context,
      id: data.id,
      cancelToken: cancelToken,
    )
      ..then((v) {
        showToastSuccess(context);
        pop(context);
        this.isRefresh = true;
        _globalKey.currentState.show();
      })
      ..catchError((e) {
        showToast(context, e.toString());
        pop(context);
      });
  }
}
