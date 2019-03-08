import 'package:house/importLib.dart';

class ReceiveCode extends BaseStatefulWidget {
  final String email;

  ReceiveCode(this.email);

  @override
  _ReceiveCodeState createState() {
    return _ReceiveCodeState();
  }
}

class _ReceiveCodeState extends BaseAppBarAndBodyState<ReceiveCode> {
  @override
  BaseAppBar appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("image/house_email_sent_ok.webp"),
          Container(
            margin: EdgeInsets.only(top: 24),
            child: Text(
              HouseValue.of(context).emailSent,
              style: TextStyle(
                color: HouseColor.black,
                fontSize: 38,
                fontFamily: "LatoRegular",
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              HouseValue.of(context)
                  .emailSentNotice
                  .replaceAll("###", widget.email),
              style: createTextStyle(color: HouseColor.gray),
              textAlign: TextAlign.center,
            ),
          ),
          UserButton(
            () {
              pop(context);
            },
            HouseValue.of(context).emailSentOK,
            top: 100,
          ),
        ],
      ),
    );
  }
}
