import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';

class AgencyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        iconSize: 24,
        activeColor: HouseColor.green,
        inactiveColor: HouseColor.gray,
        backgroundColor: HouseColor.white,
        border: Border(),
        items: [
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.homeIcon),
            title: Text(HouseValue.of(context).properties),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.caseIcon),
            title: Text("All Requests"),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.orderIcon),
            title: Text(HouseValue.of(context).orders),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.vendorIcon),
            title: Text(HouseValue.of(context).vendor),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.meIcon),
            title: Text(HouseValue.of(context).me),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return [
          HouseHome(),
          CasesPage(),
          AgencyOrderPage(),
          VendorListHome(),
          MeHome(),
        ][index];
      },
    );
  }
}
