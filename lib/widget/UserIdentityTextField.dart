import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';

class UserIdentityTextField extends BaseStatefulWidget {
  final ValueChanged<int> onSelectedItemChanged;
  final int index;

  UserIdentityTextField(this.onSelectedItemChanged, this.index);

  @override
  _UserIdentityTextFieldState createState() {
    return _UserIdentityTextFieldState();
  }
}

class _UserIdentityTextFieldState extends BaseState<UserIdentityTextField> {
  String initialValue = "";

  @override
  Widget build(BuildContext context) {
    if (initialValue.isEmpty) {
      initialValue = HouseValue.of(context).identity.toUpperCase();
    }
    return GestureDetector(
      onTap: () {
        buildShowCupertinoModalPopup(context);
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 36,
          top: 16,
          right: 36,
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: HouseColor.divider,
              width: 0.5,
            ),
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: <Widget>[
            Text(
              initialValue,
              style: createTextStyle(
                color: _checkInit() ? HouseColor.gray : HouseColor.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  alignment: AlignmentDirectional.center,
                  width: 48,
                  child: Transform.rotate(
                    angle: pi,
                    child: Icon(
                      HouseIcons.backIcon,
                      color: HouseColor.gray,
                      size: 14,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _checkInit() =>
      initialValue == HouseValue.of(context).identity.toUpperCase();

  Future<void> buildShowCupertinoModalPopup(BuildContext context) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: widget.index);
    return showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return _buildBottomPicker(
            CupertinoPicker.builder(
              scrollController: scrollController,
              backgroundColor: HouseColor.white,
              itemExtent: 48,
              onSelectedItemChanged: (index) {
                widget.onSelectedItemChanged(index);
                initialValue = HouseValue.of(context).identities[index];
                setState(() {});
              },
              itemBuilder: (context, index) {
                return Center(
                  child: Text(HouseValue.of(context).identities[index]),
                );
              },
              childCount: 4,
            ),
          );
        });
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 240,
      color: HouseColor.transparent,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: picker,
        ),
      ),
    );
  }
}
