import 'package:house/importLib.dart';

class LandlordHousePage extends BaseStatefulWidget {
  @override
  _LandlordHousePageState createState() {
    return _LandlordHousePageState();
  }
}

class _LandlordHousePageState
    extends BaseAppBarAndBodyState<LandlordHousePage> {
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
      title: TitleAppBar.appBarTitle(
        TypeStatus.landlord.descEn,
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
      separatorBuilder: (context, index) => SizedBox(height: 12),
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
          showToast(context, e.toString());
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
          showToast(context, e.toString());
        }).whenComplete(() {
          setState(() {});
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
