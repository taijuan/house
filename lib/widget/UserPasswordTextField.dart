import 'package:flutter/services.dart';
import 'package:house/importLib.dart';

class UserPasswordTextField extends BaseStatefulWidget {
  final TextEditingController controller;
  final String title;
  final double left, top, right, bottom;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;
  final TextInputAction textInputAction;

  UserPasswordTextField({
    @required this.controller,
    @required this.title,
    this.focusNode,
    this.left = 36,
    this.top = 0,
    this.right = 36,
    this.bottom = 0,
    this.onEditingComplete,
    this.textInputAction,
  });

  @override
  _UserPasswordTextField createState() {
    return _UserPasswordTextField();
  }
}

class _UserPasswordTextField extends BaseState<UserPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.left,
        top: widget.top,
        right: widget.right,
        bottom: widget.bottom,
      ),
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 16),
              hintText: widget.title?.toUpperCase(),
              hintStyle: createTextStyle(
                color: HouseColor.gray,
                height: 1,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: HouseColor.green),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: HouseColor.divider,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
            ),
            style: createTextStyle(),
            keyboardType: TextInputType.text,
            obscureText: _obscureText,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp(r'\w+')),
              LengthLimitingTextInputFormatter(32)
            ],
            onEditingComplete: widget.onEditingComplete,
            textInputAction: widget.textInputAction,
          ),
          FlatButton(
            onPressed: () {
              _obscureText = !_obscureText;
              setState(() {});
            },
            child: Icon(
              HouseIcons.eyesIcon,
              color: _obscureText ? HouseColor.lightGray : HouseColor.green,
            ),
          ),
        ],
      ),
    );
  }
}
