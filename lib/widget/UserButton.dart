import 'package:house/importLib.dart';

class UserButton extends BaseStatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final double left, top, right;

  UserButton(this.onPressed, this.text,
      {this.left = 36, this.right = 36, this.top = 24});

  @override
  _UserButtonState createState() {
    return _UserButtonState();
  }
}

class _UserButtonState extends BaseState<UserButton> {
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: widget.left, right: widget.right, top: widget.top),
      child: FlatButton(
        onPressed: widget.onPressed,
        color: HouseColor.green,
        disabledColor: HouseColor.gray,
        child: Container(
          alignment: Alignment.center,
          height: 42,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.text,
                  style: createTextStyle(color: HouseColor.white),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
