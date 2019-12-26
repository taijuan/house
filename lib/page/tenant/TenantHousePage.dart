import 'package:house/importLib.dart';

class TenantHousePage extends BaseStatefulWidget {
  @override
  _TenantHousePageState createState() {
    return _TenantHousePageState();
  }
}

class _TenantHousePageState extends BaseAppBarAndBodyState<TenantHousePage> {
  final List<House> _data = [];

  @override
  void initState() {
    backgroundColor = HouseColor.lightGray;
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      decoration: BoxDecoration(color: HouseColor.green),
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).properties,
        style: createTextStyle(
          color: HouseColor.white,
          fontSize: 17,
          fontFamily: fontFamilySemiBold,
        ),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshListView(
      padding: EdgeInsets.symmetric(vertical: 12),
      itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: HouseBigCard(_data[index]),
          ),
      separatorBuilder: (context, index) => Container(height: 12),
      itemCount: _data.length,
      onRefresh: () async {
        await getHouseList(
          context,
          1,
          cancelToken: cancelToken,
        ).then((data) {
          this._data.clear();
          this._data.addAll(data);
        }).catchError((e) {
          showMsgToast(context, e.toString());
        }).whenComplete(() {
          setState(() {});
        });
      },
      onLoadMore: (page) async {
        await getHouseList(
          context,
          page,
          cancelToken: cancelToken,
        ).then((data) {
          this._data.addAll(data);
        }).catchError((e) {
          showMsgToast(context, e.toString());
        }).whenComplete(() {
          setState(() {});
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
