import 'package:flutter/material.dart';
import 'package:house/base/BaseState.dart';

export 'package:house/base/BaseStatefulWidget.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  @override
  BaseState createState();

  const BaseStatefulWidget({Key key}) : super(key: key);
}
