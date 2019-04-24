import 'package:house/importLib.dart';

class VendorListHome extends BaseStatefulWidget {
  @override
  _VendorListHomeState createState() => _VendorListHomeState();
}

class _VendorListHomeState extends BaseAppBarAndBodyState<VendorListHome> {
  final List<User> _data = [];

  @override
  void initState() {
    Future.delayed(Duration()).whenComplete(() {
//      _refreshKey.currentState.show();
    });
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) => TitleAppBar(
        context: context,
        title: TitleAppBar.appBarTitle(HouseValue.of(context).vendorList),
        menu: TitleAppBar.appBarMenu(
          context,
          onPressed: () {
            push(context, FilterPage(isFromHouse: false));
          },
          menu: Text(
            HouseValue.of(context).filter,
            style: createTextStyle(color: HouseColor.green),
          ),
        ),
      );

  @override
  Widget body(BuildContext context) {
    return Provide<ProviderVendorReLoad>(
      builder: (context, child, reload) => RefreshListView(
            key: ValueKey(reload.reloadNum),
            itemBuilder: (context, index) => _buildItem(_data[index]),
            separatorBuilder: (context, index) => Container(
                  color: HouseColor.divider,
                  height: .5,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                ),
            itemCount: _data.length,
            onRefresh: () async {
              await queryRepairUsers(
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
              await queryRepairUsers(
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
          ),
    );
  }

  Widget _buildItem(User data) {
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      onPressed: () {
        push(context, VendorDetailHome(data.id));
      },
      child: SizedBox(
        height: 80,
        child: Row(
          children: <Widget>[
            CacheImage(
              DataUtils.getImageUrl(data.headImage),
              width: 80,
              height: 80,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    data.companyName,
                    style: createTextStyle(
                      fontFamily: fontFamilySemiBold,
                      height: 1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    data.address ?? "",
                    style: createTextStyle(
                      color: HouseColor.gray,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
