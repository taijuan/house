import 'package:flutter/services.dart';
import 'package:house/importLib.dart';

class UserCodeTextField extends BaseStatefulWidget {
  final TextEditingController userCodeController;
  final VoidCallback onPressed;
  final FocusNode focusNode;

  UserCodeTextField(
    this.userCodeController,
    this.onPressed, {
    this.focusNode,
  });

  @override
  _UserCodeTextFieldState createState() {
    return _UserCodeTextFieldState();
  }
}

class _UserCodeTextFieldState extends BaseState<UserCodeTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 36, right: 36),
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          TextFormField(
            controller: widget.userCodeController,
            enabled: true,
            decoration: InputDecoration(
              enabled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
              hintText: HouseValue.of(context).verificationCode.toUpperCase(),
              hintStyle: createTextStyle(
                color: HouseColor.gray,
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
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp(r'\w+')),
              LengthLimitingTextInputFormatter(6)
            ],
            focusNode: widget.focusNode,
          ),
          ShutDownButton(widget.onPressed)
        ],
      ),
    );
  }
}
