import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:house/importLib.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  int page = 0;
  ClassicHeader header = ClassicHeader();
  ClassicFooter footer = ClassicFooter();
  RefreshController controller = RefreshController();
  bool isShowLoading = true;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onRefresh()
        ..then((a) {
          this.page = 1;
        })
        ..whenComplete(() {
          controller.refreshCompleted();
          setState(() {
            isShowLoading = false;
          });
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isShowLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return SmartRefresher(
      controller: controller,
      header: header,
      footer: footer,
      enablePullUp: widget.onLoadMore != null,
      enablePullDown: true,
      onRefresh: () {
        widget.onRefresh().then((a) {
          this.page = 1;
        }).whenComplete(() {
          controller.refreshCompleted();
        });
      },
      child: ListView.separated(
        padding: widget.padding,
        itemBuilder: widget.itemBuilder,
        separatorBuilder: widget.separatorBuilder,
        itemCount: widget.itemCount,
      ),
      onLoading: widget.onLoadMore != null
          ? () {
              widget.onLoadMore(this.page + 1).then((a) {
                this.page++;
              }).whenComplete(() {
                controller.loadComplete();
              });
            }
          : null,
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
  ClassicHeader header = ClassicHeader();
  ClassicFooter footer = ClassicFooter();
  RefreshController controller = RefreshController(initialRefresh: true);
  int page = 0;
  bool isShowLoading = true;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onRefresh()
        ..then((a) {
          this.page = 1;
        })
        ..whenComplete(() {
          controller.refreshCompleted();
          setState(() {
            isShowLoading = false;
          });
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isShowLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return SmartRefresher(
      controller: controller,
      header: header,
      footer: footer,
      enablePullUp: widget.onLoadMore != null,
      enablePullDown: true,
      onRefresh: () {
        widget.onRefresh().then((a) {
          this.page = 1;
        }).whenComplete(() {
          controller.refreshCompleted();
        });
      },
      child: CustomScrollView(
        slivers: widget.slivers,
      ),
      onLoading: widget.onLoadMore != null
          ? () {
              widget.onLoadMore(this.page + 1).then((a) {
                this.page++;
              }).whenComplete(() {
                controller.loadComplete();
              });
            }
          : null,
    );
  }
}
