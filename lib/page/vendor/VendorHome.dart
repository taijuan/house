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
            icon: Icon(HouseIcons.homeIcon),
            title: Text(HouseValue.of(context).inquiries),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.caseIcon),
            title: Text(HouseValue.of(context).quote),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.orderIcon),
            title: Text(HouseValue.of(context).job),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.meIcon),
            title: Text(HouseValue.of(context).me),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return [
          VendorOrderPage(
            title: HouseValue.of(context).inquiries,
            body: OrdersHome(status: TypeStatus.repairToQuote.value),
          ),
          VendorOrderPage(
            title: HouseValue.of(context).quote,
            body: OrdersHome(
              queryStatus:
                  "${TypeStatus.repairPending.value},${TypeStatus.repairProcessing.value},${TypeStatus.repairRejected.value}",
            ),
          ),
          VendorOrderPage(
            title: HouseValue.of(context).job,
            body: OrdersHome(
              queryStatus:
                  "${TypeStatus.repairConfirm.value},${TypeStatus.repairFinished.value},${TypeStatus.repairClosed.value}",
            ),
          ),
          MeHome(),
        ][index];
      },
    );
  }
}
