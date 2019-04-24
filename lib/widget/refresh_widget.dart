import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:house/importLib.dart';

typedef Future<void> OnRefresh();
typedef Future<void> OnLoadMore(int);

class RefreshListView extends StatefulWidget {
  final OnRefresh onRefresh;
  final OnLoadMore onLoadMore;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final int itemCount;
  final EdgeInsetsGeometry padding;

  const RefreshListView({
    Key key,
    @required this.onRefresh,
    this.onLoadMore,
    @required this.itemBuilder,
    @required this.separatorBuilder,
    @required this.itemCount,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  State createState() => RefreshListViewState();
}

class RefreshListViewState extends State<RefreshListView> {
  final ClassicsHeader _defaultHeader = ClassicsHeader(
    key: new GlobalKey<ClassicsHeaderState>(),
    bgColor: HouseColor.transparent,
    textColor: HouseColor.black,
    moreInfoColor: HouseColor.black,
    showMore: true,
  );
  final ClassicsFooter _defaultFooter = ClassicsFooter(
    key: new GlobalKey<ClassicsFooterState>(),
    bgColor: HouseColor.transparent,
    textColor: HouseColor.black,
    moreInfoColor: HouseColor.black,
    showMore: true,
  );
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      firstRefresh: true,
      behavior: ScrollOverBehavior(),
      firstRefreshWidget: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        alignment: AlignmentDirectional.center,
        child: Text(
          "loading...",
          style: createTextStyle(),
        ),
      ),
      emptyWidget: Container(
        width: double.infinity,
        height: 360,
        alignment: AlignmentDirectional.center,
        child: Text(
          "empty...",
          style: createTextStyle(),
        ),
      ),
      onRefresh: () async {
        await widget.onRefresh().then((a) {
          this.page = 1;
        });
      },
      refreshHeader: _defaultHeader,
      child: ListView.separated(
        padding: widget.padding,
        itemBuilder: widget.itemBuilder,
        separatorBuilder: widget.separatorBuilder,
        itemCount: widget.itemCount,
      ),
      loadMore: widget.onLoadMore != null
          ? () {
              widget.onLoadMore(this.page + 1).then((a) {
                this.page++;
              });
            }
          : null,
      refreshFooter: _defaultFooter,
      autoLoad: false,
    );
  }
}

class RefreshCustomScrollView extends StatefulWidget {
  final OnRefresh onRefresh;
  final OnLoadMore onLoadMore;
  final List<Widget> slivers;

  const RefreshCustomScrollView({
    Key key,
    @required this.onRefresh,
    this.onLoadMore,
    @required this.slivers,
  }) : super(key: key);

  @override
  State createState() => RefreshCustomScrollViewState();
}

class RefreshCustomScrollViewState extends State<RefreshCustomScrollView> {
  final ClassicsHeader _defaultHeader = ClassicsHeader(
    key: new GlobalKey<ClassicsHeaderState>(),
    bgColor: HouseColor.transparent,
    textColor: HouseColor.black,
    moreInfoColor: HouseColor.black,
    showMore: true,
  );
  final ClassicsFooter _defaultFooter = ClassicsFooter(
    key: new GlobalKey<ClassicsFooterState>(),
    bgColor: HouseColor.transparent,
    textColor: HouseColor.black,
    moreInfoColor: HouseColor.black,
    showMore: true,
  );
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      firstRefresh: true,
      behavior: ScrollOverBehavior(),
      firstRefreshWidget: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        alignment: AlignmentDirectional.center,
        child: Text("loading..."),
      ),
      emptyWidget: Container(
        width: double.infinity,
        height: 360,
        alignment: AlignmentDirectional.center,
        child: Text("empty..."),
      ),
      onRefresh: () async {
        await widget.onRefresh().then((a) {
          this.page = 1;
        });
      },
      refreshHeader: _defaultHeader,
      child: CustomScrollView(
        slivers: widget.slivers,
      ),
      loadMore: widget.onLoadMore != null
          ? () {
              widget.onLoadMore(this.page + 1).then((a) {
                this.page++;
              });
            }
          : null,
      refreshFooter: _defaultFooter,
      autoLoad: false,
    );
  }
}
