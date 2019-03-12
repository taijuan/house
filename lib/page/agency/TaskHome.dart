import 'package:house/importLib.dart';

class TaskHome extends BaseStatefulWidget {
  @override
  _TaskHomeState createState() => _TaskHomeState();
}

class _TaskHomeState extends BaseAppBarAndBodyState<TaskHome>
    with
        SingleTickerProviderStateMixin<TaskHome>{
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: SizedBox(
        width: 160,
        child: TabBar(
          tabs: [
            Tab(
              text: HouseValue.of(context).caseStr,
            ),
            Tab(
              text: HouseValue.of(context).orders,
            ),
          ],
          labelPadding: EdgeInsets.only(),
          indicatorColor: HouseColor.green,
          indicatorWeight: 2,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 12),
          controller: _controller,
          unselectedLabelStyle: createTextStyle(
            fontSize: 17,
            fontFamily: fontFamilySemiBold,
          ),
          labelStyle: createTextStyle(
            color: HouseColor.green,
            fontSize: 17,
            fontFamily: fontFamilySemiBold,
          ),
          unselectedLabelColor: HouseColor.black,
          labelColor: HouseColor.green,
        ),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        TaskListHome(),
        AgencyOrderHome(),
      ],
      controller: _controller,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
