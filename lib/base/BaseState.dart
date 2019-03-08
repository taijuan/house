import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:house/importLib.dart';

abstract class BaseState<T extends BaseStatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  final CancelToken cancelToken = CancelToken();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
    super.dispose();
  }
}
