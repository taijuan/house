import 'package:house/importLib.dart';

class VendorHome extends BaseStatefulWidget {
  @override
  _VendorHomeState createState() {
    return _VendorHomeState();
  }
}

class _VendorHomeState extends BaseAppBarAndBodyState<VendorHome> {
  bool _isShowPop = false;
  TypeStatus _curTypeStatus = TypeStatus.vendorOrderStatus[0];

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      navigatorBack: Container(width: 0, height: 0),
      title: _buildTypeStatus(context),
      decoration: BoxDecoration(color: HouseColor.green),
      menu: TitleAppBar.menuToMe(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildDataList(),
        _buildPop(),
      ],
    );
  }

  Widget _buildDataList() {
    return OrdersHome(
      status: _curTypeStatus.value,
    );
  }

  Widget _buildPop() {
    if (_isShowPop) {
      return GestureDetector(
        child: Container(
          color: Color(0x30000000),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(),
            itemBuilder: (context, index) {
              return MaterialButton(
                color: HouseColor.white,
                onPressed: () {
                  _curTypeStatus = TypeStatus.vendorOrderStatus[index];
                  _isShowPop = false;
                  setState(() {});
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  alignment: Alignment.center,
                  child: Text(
                    TypeStatus.vendorOrderStatus[index].descEn,
                    style: createTextStyle(
                      color:
                          _curTypeStatus == TypeStatus.vendorOrderStatus[index]
                              ? HouseColor.green
                              : HouseColor.black,
                      fontSize: 17,
                      fontFamily: fontFamilySemiBold,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 1,
                color: HouseColor.divider,
              );
            },
            itemCount: TypeStatus.vendorOrderStatus.length,
          ),
        ),
        onTap: () {
          _isShowPop = false;
          setState(() {});
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildTypeStatus(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 48,
      child: FlatButton(
        onPressed: () {
          _isShowPop = true;
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _curTypeStatus.descEn,
              style: createTextStyle(
                color: HouseColor.white,
                fontSize: 17,
                fontFamily: fontFamilySemiBold,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Image.asset("image/house_unfold_white.webp"),
          ],
        ),
      ),
    );
  }
}
