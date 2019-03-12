import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';

class AgencyHome extends BaseStatefulWidget {
  @override
  _AgencyHomeState createState() => _AgencyHomeState();
}

const IconData home = IconData(0xe612, fontFamily: 'tabIcon');
const IconData task = IconData(0xe607, fontFamily: 'tabIcon');
const IconData vendor = IconData(0xe608, fontFamily: 'tabIcon');
const IconData me = IconData(0xe606, fontFamily: 'tabIcon');

class _AgencyHomeState extends BaseState<AgencyHome> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        iconSize: 28,
        activeColor: HouseColor.green,
        inactiveColor: HouseColor.gray,
        backgroundColor: HouseColor.white,
        border: Border(),
        items: [
          BottomNavigationBarItem(
            icon: Icon(home),
            title: Text(HouseValue.of(context).properties),
          ),
          BottomNavigationBarItem(
            icon: Icon(task),
            title: Text(HouseValue.of(context).task),
          ),
          BottomNavigationBarItem(
            icon: Icon(vendor),
            title: Text(HouseValue.of(context).vendor),
          ),
          BottomNavigationBarItem(
            icon: Icon(me),
            title: Text(HouseValue.of(context).me),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return [HouseHome(), TaskHome(), VendorListHome(), MeHome()][index];
      },
    );
  }
}
