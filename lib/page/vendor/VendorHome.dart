import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';

class VendorHome extends StatelessWidget {
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
            icon: Icon(HouseIcons.quoteIcon),
            title: Text(TypeStatus.repairToQuote.descEn),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.pendingIcon),
            title: Text(TypeStatus.repairPending.descEn),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.processingIcon),
            title: Text(TypeStatus.repairProcessing.descEn),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.allIcon),
            title: Text("All"),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.meIcon),
            title: Text(HouseValue.of(context).me),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return [
          VendorOrderPage(data: TypeStatus.repairToQuote),
          VendorOrderPage(data: TypeStatus.repairPending),
          VendorOrderPage(data: TypeStatus.repairProcessing),
          VendorPage(),
          MeHome(),
        ][index];
      },
    );
  }
}
