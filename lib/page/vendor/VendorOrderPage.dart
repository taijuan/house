import 'package:house/importLib.dart';

class VendorOrderPage extends StatelessWidget {
  final Widget body;
  final String title;

  const VendorOrderPage({
    Key key,
    this.body,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        context: context,
        title: TitleAppBar.appBarTitle(
          title,
          style: createTextStyle(
            fontSize: 17,
            fontFamily: fontFamilySemiBold,
            color: HouseColor.white,
          ),
        ),
        decoration: BoxDecoration(color: HouseColor.green),
      ),
      body: body,
    );
  }
}
