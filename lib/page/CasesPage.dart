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

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      decoration: _titleBgColor,
      title: TitleAppBar.appBarTitle(
        "${widget.data == null ? "All" : "House"} requsts",
        style: _titleTextColor,
      ),
      navigatorBack:
          widget.data == null ? null : TitleAppBar.navigatorBackBlack(context),
    );
  }

  get _titleBgColor {
    if (Provide.value<ProviderUser>(context).isTenant()) {
      return BoxDecoration(color: HouseColor.green);
    } else {
      return null;
    }
  }

  get _titleTextColor {
    if (Provide.value<ProviderUser>(context).isTenant()) {
      return createTextStyle(
        color: HouseColor.white,
        fontSize: 17,
        fontFamily: fontFamilySemiBold,
      );
    } else {
      return createTextStyle(
        fontSize: 17,
        fontFamily: fontFamilySemiBold,
      );
    }
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
    if (Provide.value<ProviderUser>(context).isTenant() &&
        widget.data != null) {
      return Positioned(
        bottom: 24,
        child: FlatButton(
          onPressed: () {
            push(
              context,
              PublishCasePage(widget.data),
            );
          },
          child: Image.asset("image/house_add.webp"),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  _buildRefresh() {
    return Provide<ProviderOrderReLoad>(
      builder: (_, a, reload) => RefreshListView(
            key: ValueKey(reload.reloadNum),
            itemBuilder: (context, index) => _buildItem(_data[index]),
            separatorBuilder: (context, index) => Container(
                  height: .5,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  color: HouseColor.divider,
                ),
            itemCount: _data.length,
            onRefresh: () async {
              await selectQuestionInfoPageList(
                context,
                1,
                houseId: widget.data?.id,
                cancelToken: cancelToken,
              ).then((data) {
                this._data.clear();
                this._data.addAll(data);
              }).catchError((e) {
                showToast(context, e.toString());
              }).whenComplete(() {
                setState(() {});
              });
            },
            onLoadMore: (page) async {
              await selectQuestionInfoPageList(
                context,
                page,
                houseId: widget.data?.id,
                cancelToken: cancelToken,
              ).then((data) {
                this._data.addAll(data);
              }).catchError((e) {
                showToast(context, e.toString());
              }).whenComplete(() {
                setState(() {});
              });
            },
          ),
    );
  }

  Widget _buildItem(Question data) {
    return InkWell(
      onTap: () {
        push(
          context,
          CaseDetailPage(data),
        );
      },
      onLongPress: () {
        if (Provide.value<ProviderUser>(context).isTenant()) {
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
            houseCacheNetworkImage(
              DataUtils.getFirstImage(data.photos.content),
              width: 80,
              height: 80,
            ),
            Container(
              width: 12,
            ),
            Expanded(
              child: SizedBox(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.description,
                      style: createTextStyle(
                        height: 1,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    _getQuestionStatus(data),
                    Text(
                      data.createDate,
                      style: createTextStyle(
                        color: HouseColor.gray,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
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
        height: 1,
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
