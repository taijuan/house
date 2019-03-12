import 'package:flutter/services.dart';
import 'package:house/importLib.dart';

class UserCheckInviteCodeTextField extends BaseStatefulWidget {
  final TextEditingController userCodeController;

  UserCheckInviteCodeTextField(this.userCodeController);

  @override
  _CheckInviteCodeTextFieldState createState() {
    return _CheckInviteCodeTextFieldState();
  }
}

class _CheckInviteCodeTextFieldState
    extends BaseState<UserCheckInviteCodeTextField> {
  @override
  Widget build(BuildContext context) {
    widget.userCodeController.addListener(() {
      setState(() {});
    });
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 24),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _index(0) ? HouseColor.green : HouseColor.gray,
                  ),
                ),
                child: Text(
                  _getIndexNumber(0),
                  style: createTextStyle(
                    fontSize: 17,
                    fontFamily: fontFamilySemiBold,
                  ),
                ),
              ),
              Expanded(child: Container(width: 0, height: 0)),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _index(1) ? HouseColor.green : HouseColor.gray,
                  ),
                ),
                child: Text(
                  _getIndexNumber(1),
                  style: createTextStyle(
                    fontSize: 17,
                    fontFamily: fontFamilySemiBold,
                  ),
                ),
              ),
              Expanded(child: Container(width: 0, height: 0)),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _index(2) ? HouseColor.green : HouseColor.gray,
                  ),
                ),
                child: Text(
                  _getIndexNumber(2),
                  style: createTextStyle(
                    fontSize: 17,
                    fontFamily: fontFamilySemiBold,
                  ),
                ),
              ),
              Expanded(child: Container(width: 0, height: 0)),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _index(3) ? HouseColor.green : HouseColor.gray,
                  ),
                ),
                child: Text(
                  _getIndexNumber(3),
                  style: createTextStyle(
                    fontSize: 17,
                    fontFamily: fontFamilySemiBold,
                  ),
                ),
              ),
              Expanded(child: Container(width: 0, height: 0)),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _index(4) ? HouseColor.green : HouseColor.gray,
                  ),
                ),
                child: Text(
                  _getIndexNumber(4),
                  style: createTextStyle(
                    fontSize: 17,
                    fontFamily: fontFamilySemiBold,
                  ),
                ),
              ),
              Expanded(child: Container(width: 0, height: 0)),
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _index(5) ? HouseColor.green : HouseColor.gray,
                  ),
                ),
                child: Text(
                  _getIndexNumber(5),
                  style: createTextStyle(
                    fontSize: 17,
                    fontFamily: fontFamilySemiBold,
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: "",
              fillColor: HouseColor.transparent,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            controller: widget.userCodeController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp(r'\w+')),
              LengthLimitingTextInputFormatter(6)
            ],
            cursorColor: HouseColor.transparent,
            cursorWidth: 0,
            cursorRadius: Radius.circular(0),
            style: TextStyle(color: HouseColor.transparent),
          ),
        ],
      ),
    );
  }

  String _getIndexNumber(index) {
    var a = widget.userCodeController?.text ?? "";
    if (a.length > index) {
      return a[index];
    } else {
      return "";
    }
  }

  bool _index(index) {
    var a = widget.userCodeController?.text?.length ?? 0;
    return a >= index;
  }
}
