import 'package:flutter/material.dart';
import 'package:house/base/BaseState.dart';
import 'package:house/importLib.dart';

class TitleAppBar extends BaseAppBar {
  final BuildContext context;
  final Widget title;
  final Widget navigatorBack;
  final Widget menu;
  final Decoration decoration, foregroundDecoration;

  TitleAppBar({
    @required this.context,
    @required this.title,
    this.navigatorBack,
    this.menu,
    this.decoration,
    this.foregroundDecoration,
  });

  @override
  _TitleAppBarState createState() => _TitleAppBarState();

  static Widget appBarTitle(String title, {TextStyle style}) {
    return Text(
      title,
      style: style ??
          createTextStyle(
            fontSize: 17,
            fontFamily: fontFamilySemiBold,
          ),
    );
  }

  static Widget navigatorBackBlack(
    BuildContext context, {
    VoidCallback onPressed,
    Widget back,
    bool willPop = false,
    Color color,
  }) {
    if (willPop && onPressed != null) {
      return WillPopScope(
          child: _back(onPressed, context, back, color),
          onWillPop: () async {
            onPressed();
            return false;
          });
    } else {
      return _back(onPressed, context, back, color);
    }
  }

  static FlatButton _back(
    VoidCallback onPressed,
    BuildContext context,
    Widget back,
    Color color,
  ) {
    return FlatButton(
      onPressed: onPressed ??
          () {
            pop(context);
          },
      padding: EdgeInsets.only(),
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        child: back ??
            Icon(
              HouseIcons.backIcon,
              color: color ?? HouseColor.black,
              size: 18,
            ),
      ),
    );
  }

  static Widget appBarMenu(BuildContext context,
      {VoidCallback onPressed, Widget menu}) {
    return FlatButton(
      onPressed: onPressed,
      padding: EdgeInsets.only(),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 48,
        child: menu ??
            Text(
              HouseValue.of(context).save,
              style: createTextStyle(color: HouseColor.green),
            ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        48.0 + MediaQuery.of(context).padding.top,
      );
}

class _TitleAppBarState extends BaseState<TitleAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.decoration ?? BoxDecoration(),
      foregroundDecoration: widget.foregroundDecoration ??
          BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0x19000000),
              ),
            ),
          ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: 48.0 + MediaQuery.of(context).padding.top,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          widget.title ?? Container(width: 0, height: 0),
          Positioned(
            top: 0,
            left: 0,
            height: 48,
            child: widget.navigatorBack ?? Container(width: 0, height: 0),
          ),
          Positioned(
            top: 0,
            right: 0,
            height: 48,
            child: widget.menu ?? Container(width: 0, height: 0),
          ),
        ],
      ),
    );
  }
}
