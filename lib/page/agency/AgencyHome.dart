import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';

class AgencyHome extends BaseStatefulWidget {
  @override
  _AgencyHomeState createState() => _AgencyHomeState();
}

class _AgencyHomeState extends BaseState<AgencyHome> {
  int _index = 0;

  BottomNavigationBarItem _tabItem(
    String icon,
    String activeIcon,
    String text, {
    bool showHot = false,
  }) {
    return BottomNavigationBarItem(
      icon: Image.asset(icon),
      activeIcon: Image.asset(activeIcon),
      title: Text(
        text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _index,
        children: <Widget>[HouseHome(), TaskHome(), VendorListHome(), MeHome()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 24.0,
        fixedColor: HouseColor.green,
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            this._index = index;
          });
        },
        items: [
          _tabItem(
            "image/house_agency_properties_gray.webp",
            "image/house_agency_properties_green.webp",
            HouseValue.of(context).properties,
          ),
          _tabItem(
            "image/house_agency_task_gray.webp",
            "image/house_agency_task_green.webp",
            HouseValue.of(context).task,
          ),
          _tabItem(
            "image/house_agency_vendor_grey.webp",
            "image/house_agency_vendor_green.webp",
            HouseValue.of(context).vendor,
          ),
          _tabItem(
            "image/house_agency_me_gray.webp",
            "image/house_agency_me_green.webp",
            HouseValue.of(context).me,
            showHot: true,
          ),
        ],
      ),
    );
  }
}
