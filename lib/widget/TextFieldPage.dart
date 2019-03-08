import 'package:house/importLib.dart';

class TextFieldPage extends BaseStatefulWidget {
  final String title;
  final String value;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLength, maxLines;

  TextFieldPage(
    this.title, {
    this.maxLength,
    this.maxLines,
    this.value: "",
    this.keyboardType: TextInputType.text,
    this.textInputAction: TextInputAction.newline,
  });

  @override
  _TextFieldPageState createState() {
    return _TextFieldPageState();
  }
}

class _TextFieldPageState extends BaseAppBarAndBodyState<TextFieldPage> {
  TextEditingController textEditingController;

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(widget.title),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      menu: TitleAppBar.appBarMenu(context, onPressed: () {
        pop<String>(context, result: textEditingController.text);
      }),
    );
  }

  @override
  Widget body(BuildContext context) {
    textEditingController =
        textEditingController ?? TextEditingController(text: widget.value);
    return Container(
      padding: EdgeInsets.all(16),
      child: TextFormField(
        style: createTextStyle(),
        keyboardType: widget.keyboardType,
        controller: textEditingController,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              width: 0.5,
              color: HouseColor.lightGray,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              width: 1,
              color: HouseColor.green,
            ),
          ),
          hintStyle: createTextStyle(color: HouseColor.gray),
          hintText: HouseValue.of(context).pleaseEnterThe + widget.title,
        ),
        maxLength: widget.maxLength,
      ),
    );
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    super.dispose();
  }
}
