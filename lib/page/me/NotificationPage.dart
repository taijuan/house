import 'package:house/importLib.dart';

class NotificationPage extends BaseStatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends BaseAppBarAndBodyState<NotificationPage> {
  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).notifications,
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshListView(
      itemBuilder: (context, index) {},
      separatorBuilder: (context, index) {},
      itemCount: 0,
      onRefresh: () async {},
      onLoadMore: (page) async {},
    );
  }
}
