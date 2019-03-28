import 'package:house/importLib.dart';

class CasesPage extends BaseStatefulWidget {
  final House data;

  CasesPage({
    this.data,
  });

  @override
  _CasesPageState createState() => _CasesPageState();
}

class _CasesPageState extends BaseAppBarAndBodyState<CasesPage> {
  final List<Question> _data = [];
  final GlobalKey<RefreshWidgetState> _refreshKey =
      GlobalKey<RefreshWidgetState>();
  int _curPage = 1;

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).cases,
      ),
      navigatorBack:
          widget.data == null ? null : TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          _buildRefresh(),
          _addButton(),
        ],
      );

  Widget _addButton() {
    if (User.getUserSync().type.value == TypeStatus.tenant.value &&
        widget.data != null) {
      return Positioned(
        bottom: 24,
        child: FlatButton(
          onPressed: () {
            push(
              context,
              PublishCasePage(widget.data),
            ).then((isRefresh) {
              if (isRefresh == true) {
                _refreshKey.currentState?.show();
              }
            });
          },
          child: Image.asset("image/house_add.webp"),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  void initState() {
    Future.delayed(Duration()).whenComplete(() {
      _refreshKey.currentState?.show();
    });
    super.initState();
  }

  _buildRefresh() {
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
                  height: 0.5,
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
        await selectQuestionInfoPageList(
          context,
          1,
          houseId: widget.data?.id,
          cancelToken: cancelToken,
        ).then((data) {
          this._data.clear();
          this._data.addAll(data);
          if (data.length >= 10) {
            _refreshKey.currentState.more();
          } else if(DataUtils.isEmptyList(data)) {
            _refreshKey.currentState.refreshNoData();
          }else{
            _refreshKey.currentState.loadMoreNoData();
          }
          _curPage = 1;
          setState(() {});
        }).catchError((e) {
          showToast(context, e.toString());
        });
      },
      onLoadMore: () async {
        await selectQuestionInfoPageList(
          context,
          _curPage + 1,
          houseId: widget.data?.id,
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

  Widget _buildItem(Question data) {
    return InkWell(
      onTap: () {
        push(
          context,
          CaseDetailPage(data),
        )..then((isRefresh) {
            if (isRefresh == true) {
              _refreshKey.currentState.show();
            }
          });
      },
      onLongPress: () {
        if (User.getUserSync().type.value != TypeStatus.tenant.value) {
          return;
        }
        if (data.status.value != TypeStatus.questionNew.value) {
          return;
        }
        showAlertDialog(
          context,
          content: HouseValue.of(context).areYouSureToDeleteThisCase.replaceAll(
                "#",
                data.description,
              ),
          onOkPressed: () {
            _deleteQuestionInfoById(data);
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            HouseCacheNetworkImage(
              DataUtils.getFirstImage(data.photos.content),
              width: 60,
              height: 60,
            ),
            Container(
              width: 12,
            ),
            Expanded(
              child: SizedBox(
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      data.description,
                      style: createTextStyle(height: 1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: <Widget>[
                        _getQuestionStatus(data),
                        SizedBox(width: 12),
                        Text(
                          data.createDate,
                          style: createTextStyle(
                              color: HouseColor.gray, fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _getQuestionStatus(Question data) {
    return Text(
      data.status.descEn ?? "",
      style: TextStyle(
        fontSize: 13,
        fontFamily: "LatoSemibold",
        color: _getTextColor(data),
      ),
    );
  }

  Color _getTextColor(Question data) {
    if (data.status.value == TypeStatus.questionFinished.value) {
      return HouseColor.green;
    } else if (data.status.value == TypeStatus.questionRejected.value) {
      return HouseColor.gray;
    } else {
      return HouseColor.red;
    }
  }

  @override
  bool get wantKeepAlive => true;

  _deleteQuestionInfoById(Question data) {
    showLoadingDialog(context);
    deleteQuestionInfoById(
      context: context,
      id: data.id,
      cancelToken: cancelToken,
    )
      ..then((v) {
        showToastSuccess(context);
        pop(context);
        setState(() {
          _data.remove(data);
        });
      })
      ..catchError((e) {
        showToast(context, e.toString());
        pop(context);
      });
  }
}
