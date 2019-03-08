import 'package:house/importLib.dart';

class UserNameTextField extends BaseStatefulWidget {
  final TextEditingController userNameController;
  final bool enabled;
  final String title;
  final TextInputType keyboardType;
  final double left, top, right, bottom;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;
  final TextInputAction textInputAction;

  UserNameTextField({
    this.userNameController,
    this.enabled = true,
    @required this.title,
    this.keyboardType = TextInputType.emailAddress,
    this.focusNode,
    this.left = 36,
    this.top = 0,
    this.right = 36,
    this.bottom = 0,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.done,
  });

  @override
  _UserNameTextFieldState createState() {
    return _UserNameTextFieldState();
  }
}

class _UserNameTextFieldState extends BaseState<UserNameTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.left,
        top: widget.top,
        right: widget.right,
        bottom: widget.bottom,
      ),
      child: TextFormField(
        enabled: widget.enabled,
        focusNode: widget.focusNode,
        controller: widget.userNameController,
        decoration: InputDecoration(
          enabled: widget.enabled,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
          hintText: widget.title?.toUpperCase(),
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
        onEditingComplete: widget.onEditingComplete,
        textInputAction: widget.textInputAction,
      ),
    );
  }
}
