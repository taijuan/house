import 'package:url_launcher/url_launcher.dart';

class IntentUtils {
  const IntentUtils();

  static void tel(String tel) async {
    tel = "tel:${tel ?? ""}";
    if (await canLaunch(tel)) {
      await launch(tel);
    }
  }

  static void geo(String address) async {
    address = "geo:0,0?q=$address";
    if (await canLaunch(address)) {
      await launch(address);
    }
  }

  static void mailTo(String mail) async {
    mail = "mailto:$mail";
    if (await canLaunch(mail)) {
      await launch(mail);
    }
  }
}
