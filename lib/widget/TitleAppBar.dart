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

  static Widget navigatorBackBlack(BuildContext context,
      {VoidCallback onPressed, Widget back}) {
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
        child: back ?? Image.asset("image/house_back_black.webp"),
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

  static Widget menuToMe(BuildContext context) {
    return FlatButton(
      onPressed: () {
        push(context, MeHome());
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            child: Image.asset("image/house_about_me.webp"),
            padding: EdgeInsets.all(2),
          ),
          Positioned(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: HouseColor.red,
              ),
              alignment: AlignmentDirectional.center,
            ),
            top: 0,
            right: 0,
          ),
        ],
      ),
    );
  }
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
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top * 0.8),
      width: MediaQuery.of(context).size.width,
      height: 48.0 + MediaQuery.of(context).padding.top * 0.8,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          widget.title ?? Container(),
          Positioned(
            top: 0,
            left: 0,
            height: 48,
            child: widget.navigatorBack ?? Container(),
          ),
          Positioned(
            top: 0,
            right: 0,
            height: 48,
            child: widget.menu ?? Container(),
          ),
        ],
      ),
    );
  }
}
