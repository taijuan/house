import 'package:house/importLib.dart';

class VendorOrderPage extends StatelessWidget {
  final TypeStatus data;

  const VendorOrderPage({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        context: context,
        title: TitleAppBar.appBarTitle(
          data.descEn,
          style: createTextStyle(
            fontSize: 17,
            fontFamily: fontFamilySemiBold,
            color: HouseColor.white,
          ),
        ),
        decoration: BoxDecoration(color: HouseColor.green),
      ),
      body: OrdersHome(
        status: data.value,
      ),
    );
  }
}
