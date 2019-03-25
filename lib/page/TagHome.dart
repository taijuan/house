import 'package:house/importLib.dart';

class TagHome extends BaseStatefulWidget {
  final List<Tag> selectData;
  final bool isSingle;

  TagHome({
    this.selectData,
    this.isSingle: false,
  });

  @override
  _TagHomeState createState() {
    return _TagHomeState();
  }
}

class _TagHomeState extends BaseAppBarAndBodyState<TagHome> {
  final GlobalKey<RefreshIndicatorState> _globalKey =
      GlobalKey<RefreshIndicatorState>();
  final List<Tag> _data = [];

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
      title: TitleAppBar.appBarTitle(HouseValue.of(context).type),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      menu: TitleAppBar.appBarMenu(context, onPressed: () {
        pop<List<Tag>>(
          context,
          result: _data.where((v) {
            return v.checked;
          }).toList(),
        );
      }),
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshIndicator(
      key: _globalKey,
      semanticsLabel: "",
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
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
          )
        ],
      ),
      onRefresh: () async {
        await getVendorCertificateType(
          context,
          cancelToken: cancelToken,
        ).then((data) async {
          await _mapData(data);
        }).catchError((e) {
          LogUtils.log(e);
          showToast(context, e.toString());
        });
      },
    );
  }

  Future _mapData(List<Tag> data) async {
    this._data.clear();
    this._data.addAll(data);
    this._data.forEach((tag) {
      tag.checked = widget.selectData.map((tag) {
        return tag.id;
      }).contains(tag.id);
    });
    setState(() {});
  }

  Widget _buildItem(Tag data) {
    return FlatButton(
      onPressed: () {
        if (widget.isSingle) {
          _data.forEach((tag) {
            tag.checked = false;
          });
          data.checked = true;
        } else {
          data.checked = !data.checked;
        }
        setState(() {});
      },
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              data.name,
              style: createTextStyle(),
            ),
          ),
          data.checked
              ? Icon(
                  HouseIcons.checkOkIcon,
                  color: HouseColor.green,
                  size: 18,
                )
              : Icon(
                  HouseIcons.unCheckIcon,
                  color: HouseColor.gray,
                  size: 18,
                ),
        ],
      ),
    );
  }
}
