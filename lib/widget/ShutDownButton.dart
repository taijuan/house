import 'dart:async';

import 'package:house/importLib.dart';

class ShutDownButton extends BaseStatefulWidget {
  final VoidCallback onPressed;

  ShutDownButton(this.onPressed);

  @override
  _ShutDownButtonState createState() {
    return _ShutDownButtonState();
  }
}

class _ShutDownButtonState extends BaseState<ShutDownButton> {
  String _text = "";
  Timer _timer;
  int _seconds = 0;

  @override
  Widget build(BuildContext context) {
    if (_seconds == 0) {
      _text = HouseValue.of(context).sendVerificationCodeToMyEmail;
    }
    return SizedBox(
      width: 100,
      height: 36,
      child: OutlineButton(
        borderSide: BorderSide(color: HouseColor.green, width: 0.5),
        disabledBorderColor: HouseColor.divider,
        highlightColor: HouseColor.transparent,
        padding: EdgeInsets.all(0),
        onPressed: _checkSendCodeStatus() ? _startTimer : null,
        child: Text(
          _text,
          textAlign: TextAlign.center,
          style: createTextStyle(
            color: _checkSendCodeStatus() ? HouseColor.green : HouseColor.gray,
            fontSize: 11,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  bool _checkSendCodeStatus() => _seconds == 0 && widget.onPressed != null;

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  _startTimer() {
    if (widget.onPressed != null) {
      widget.onPressed();
    }
    _seconds = 60;
    _timer = new Timer.periodic(new Duration(), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }
      _seconds--;
      if (_seconds == 0) {
        _text = HouseValue.of(context).sendVerificationCodeToMyEmail;
      } else {
        _text = "$_seconds s";
      }
      LogUtils.log(_text);
      setState(() {});
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }
}
