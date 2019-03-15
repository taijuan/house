import 'package:house/importLib.dart';

class SignInAppBar extends BaseAppBar {
  final BuildContext context;
  final bool showBack;

  SignInAppBar(this.context, {this.showBack = true});

  @override
  _SignInAppBarState createState() {
    return _SignInAppBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(
        MediaQuery.of(context).size.width * 582 / 1080,
      );
}

class _SignInAppBarState extends BaseState<SignInAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 582 / 1080,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("image/house_signup_image.webp"),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            HouseValue.of(context).signIn.toUpperCase(),
            style: createTextStyle(
              color: Colors.white,
              fontSize: 27,
              fontFamily: fontFamilyBold,
            ),
          ),

          ///返回
          widget.showBack
              ? Positioned(
                  left: 0,
                  top: MediaQuery.of(context).padding.top,
                  width: 48,
                  height: 48,
                  child: FlatButton(
                    padding: EdgeInsets.only(),
                    onPressed: () {
                      pop(context);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      child: Image.asset("image/house_back_white.webp"),
                    ),
                  ),
                )
              : Container(width: 0, height: 0)
        ],
      ),
    );
  }
}
