import 'package:flutter/material.dart';

class RefreshWidget extends StatefulWidget {
  final RefreshCallback onRefresh, onLoadMore;
  final List<Widget> slivers;

  const RefreshWidget({
    @required Key key,
    @required this.onRefresh,
    this.onLoadMore,
    @required this.slivers,
  }) : super(key: key);

  @override
  State createState() => RefreshWidgetState();
}

class RefreshWidgetState extends State<RefreshWidget> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _loaderController = new ScrollController();
  VoidCallback _listener;

  final List<Widget> _data = [];
  RefreshMode refreshMode = RefreshMode.normal;

  @override
  void initState() {
    if (_listener == null) {
      _listener = () {
        if (_checkLoadMore()) {
          refreshMode = RefreshMode.loading;
          widget.onLoadMore();
          setState(() {});
        }
      };
      _loaderController.addListener(_listener);
    }
    _loaderController.addListener(_listener);
    super.initState();
  }

  bool _checkLoadMore() {
    return _loaderController.position.pixels ==
            _loaderController.position.maxScrollExtent &&
        widget.onLoadMore != null &&
        refreshMode == RefreshMode.more;
  }

  @override
  Widget build(BuildContext context) {
    _data.clear();
    _data.addAll(widget.slivers);
    _data.add(
      SliverToBoxAdapter(
        child: _buildLoadMore(),
      ),
    );

    return RefreshIndicator(
      key: _refreshKey,
      semanticsLabel: "",
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _loaderController,
        slivers: _data,
      ),
      onRefresh: () async {
        refreshMode = RefreshMode.refreshing;
        await widget.onRefresh();
      },
    );
  }

  Widget _buildLoadMore() {
    if (widget.onLoadMore == null) {
      return SizedBox.shrink();
    } else if (refreshMode == RefreshMode.normal) {
      return SizedBox.shrink();
    } else if (refreshMode == RefreshMode.refreshing) {
      return SizedBox.shrink();
    } else if (refreshMode == RefreshMode.more) {
      return Container(
        height: 48,
        alignment: Alignment.center,
      );
    } else if (refreshMode == RefreshMode.loadMoreNoData) {
      return Container(
        height: 48,
        alignment: Alignment.center,
        child: Text("No more data"),
      );
    } else if (refreshMode == RefreshMode.refreshNoData) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: AlignmentDirectional.center,
          child: Text(
            "There's no data...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
      );
    } else if (refreshMode == RefreshMode.loading) {
      return Container(
        height: 48,
        alignment: Alignment.center,
        child: SizedBox(
          width: 48,
          height: 48,
          child: RefreshProgressIndicator(),
        ),
      );
    } else if (refreshMode == RefreshMode.error) {
      return SizedBox(
        height: 48,
        child: FlatButton(
          onPressed: () {
            if (widget.onLoadMore != null && refreshMode == RefreshMode.more) {
              refreshMode = RefreshMode.loading;
              widget.onLoadMore();
              setState(() {});
            }
          },
          child: Text("error"),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  void show() async {
    await _refreshKey.currentState.show();
  }

  void more() {
    refreshMode = RefreshMode.more;
  }

  void loadMoreNoData() {
    refreshMode = RefreshMode.loadMoreNoData;
  }

  void refreshNoData() {
    refreshMode = RefreshMode.refreshNoData;
  }

  void error() {
    refreshMode = RefreshMode.error;
    setState(() {});
  }
}

enum RefreshMode {
  normal,
  refreshing,
  loading,
  more,
  refreshNoData,
  loadMoreNoData,
  error,
}
