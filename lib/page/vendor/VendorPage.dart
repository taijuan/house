import 'package:house/importLib.dart';

class VendorPage extends BaseStatefulWidget {
  @override
  _VendorPageState createState() {
    return _VendorPageState();
  }
}

class _VendorPageState extends BaseAppBarAndBodyState<VendorPage> {
  bool _isShowPop = false;
  TypeStatus _curTypeStatus = TypeStatus.repairToQuote;

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      navigatorBack: Container(width: 0, height: 0),
      title: _buildTypeStatus(context),
      decoration: BoxDecoration(color: HouseColor.green),
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
                  _curTypeStatus = TypeStatus.repairOrderStatus[index];
                  _isShowPop = false;
                  setState(() {});
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  alignment: Alignment.center,
                  child: Text(
                    TypeStatus.repairOrderStatus[index].descEn,
                    style: createTextStyle(
                      color:
                          _curTypeStatus == TypeStatus.repairOrderStatus[index]
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
            itemCount: TypeStatus.repairOrderStatus.length,
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
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                _curTypeStatus.descEn,
                style: createTextStyle(
                  color: HouseColor.white,
                  fontSize: 17,
                  fontFamily: fontFamilySemiBold,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Transform.rotate(
              angle: _isShowPop ? pi : pi + pi / 2,
              child: Icon(
                HouseIcons.backIcon,
                color: HouseColor.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
