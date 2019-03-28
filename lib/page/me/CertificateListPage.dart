import 'package:house/importLib.dart';

class CertificateListPage extends BaseStatefulWidget {
  final String userId;

  CertificateListPage({this.userId});

  @override
  _CertificateListPageState createState() {
    return _CertificateListPageState();
  }
}

class _CertificateListPageState
    extends BaseAppBarAndBodyState<CertificateListPage> {
  final List<Certificate> _data = [];
  final GlobalKey<RefreshWidgetState> _refreshKey =
      GlobalKey<RefreshWidgetState>();

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
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).certificate,
      ),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshWidget(
      key: _refreshKey,
      onRefresh: () async {
        await selectCertificatePageList(
          context,
          cancelToken: cancelToken,
          userId: widget.userId,
        ).then((data) {
          setState(() {
            _data.clear();
            _data.addAll(data);
          });
        });
      },
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              if (index.isOdd) {
                return _buildCertificateItem(_data[index ~/ 2]);
              } else {
                return Container(height: 16);
              }
            },
            childCount: _data.length * 2,
          ),
        ),
        _buildAddCertificate(),
      ],
    );
  }

  _buildAddCertificate() {
    if (widget.userId != null) {
      return SliverToBoxAdapter(
        child: Container(
          width: 0,
          height: 0,
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: FlatButton(
          onPressed: () {
            push<bool>(
              context,
              CertificatePage(data: Certificate.fromJson({})),
            ).then((refreshState) {
              if (refreshState == true) {
                _refreshKey.currentState.show();
              }
            });
          },
          color: HouseColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            alignment: Alignment.center,
            height: 160,
            child: Text.rich(
              TextSpan(
                text: "+",
                style: createTextStyle(
                  color: HouseColor.gray,
                  fontSize: 25,
                  fontFamily: fontFamilySemiBold,
                  height: 1,
                ),
                children: [
                  TextSpan(
                    text: "\n${HouseValue.of(context).certificate}",
                    style: createTextStyle(
                      color: HouseColor.gray,
                      fontSize: 17,
                      fontFamily: fontFamilyRegular,
                      height: 1,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  _buildCertificateItem(Certificate data) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: _getStatusColor(data.status),
              width: 8,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              height: 36,
              child: Row(
                children: <Widget>[
                  Text(
                    data.typeName,
                    style: createTextStyle(
                      fontSize: 17,
                      fontFamily: fontFamilySemiBold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    data.status.desc,
                    style: createTextStyle(
                      fontSize: 17,
                      fontFamily: fontFamilySemiBold,
                      color: _getStatusColor(data.status),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: HouseColor.divider,
              height: 0.5,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildNameValue(
                      name: HouseValue.of(context).licenseNo,
                      value: data.certificateNo,
                    ),
                    _buildNameValue(
                      name: HouseValue.of(context).expireDate,
                      value: data.endDate,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  Spacer(),
                  _buildDeleteBtn(data),
                  _buildViewBtn(data),
                  _buildModifyBtn(data),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildDeleteBtn(Certificate data) {
    if (widget.userId != null) {
      return Container(width: 0, height: 0);
    }
    return Container(
      height: 28,
      child: OutlineButton(
        onPressed: () {
          _deleteDialog(id: data.id);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        borderSide: BorderSide(
          color: HouseColor.gray,
          width: 0.5,
        ),
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
        child: Text(
          HouseValue.of(context).delete,
          style: createTextStyle(),
        ),
      ),
    );
  }

  Widget _buildModifyBtn(Certificate data) {
    if (widget.userId != null) {
      return Container(width: 0, height: 0);
    } else if (data.status.value == 1) {
      return SizedBox.shrink();
    }
    return Container(
      height: 28,
      child: OutlineButton(
        onPressed: () {
          push<bool>(
            context,
            CertificatePage(data: data),
          ).then((refreshState) {
            if (refreshState == true) {
              _refreshKey.currentState.show();
            }
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        borderSide: BorderSide(
          color: HouseColor.gray,
          width: 0.5,
        ),
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
        child: Text(
          HouseValue.of(context).modify,
          style: createTextStyle(),
        ),
      ),
    );
  }

  Widget _buildViewBtn(Certificate data) {
    return Container(
      height: 28,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: OutlineButton(
        onPressed: () {
          push<bool>(
            context,
            CertificatePage(
              data: data,
              isShowSubmit: false,
            ),
          ).then((refreshState) {
            if (refreshState == true) {
              _refreshKey.currentState.show();
            }
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        borderSide: BorderSide(
          color: HouseColor.gray,
          width: 0.5,
        ),
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
        child: Text(
          "View",
          style: createTextStyle(),
        ),
      ),
    );
  }

  _buildNameValue({
    String name,
    String value,
  }) {
    return Text.rich(
      TextSpan(
        text: "$name：",
        style: createTextStyle(color: HouseColor.gray, height: 1),
        children: [
          TextSpan(
            text: value,
            style: createTextStyle(
              fontFamily: fontFamilySemiBold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  _deleteDialog({String id}) {
    showAlertDialog(
      context,
      content: HouseValue.of(context).areYouSureToDeleteThisCertificate,
      onOkPressed: () {
        _delete(id: id);
      },
    );
  }

  _delete({String id}) {
    showLoadingDialog(context);
    deleteCertificate(
      context: context,
      id: id,
      cancelToken: cancelToken,
    )
      ..then((data) {
        pop(context);
        setState(() {
          _data.removeWhere((a) => a.id == id);
        });
      })
      ..catchError((e) {
        pop(context);
        showToast(context, e.toString());
      });
  }

  _getStatusColor(TypeStatus data) {
    if (data.value == 0) {
      return HouseColor.yellow;
    } else if (data.value == 1) {
      return HouseColor.green;
    } else {
      return HouseColor.red;
    }
  }
}
