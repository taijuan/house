import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';

class TenantHome extends StatelessWidget {
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
            title: Text(HouseValue.of(context).cases),
          ),
          BottomNavigationBarItem(
            icon: Icon(HouseIcons.meIcon),
            title: Text(HouseValue.of(context).me),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return [
          TenantHousePage(),
          CasesPage(),
          MeHome(),
        ][index];
      },
    );
  }
}
