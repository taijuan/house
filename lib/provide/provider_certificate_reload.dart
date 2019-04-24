import 'package:house/importLib.dart';

class ProviderCertificateReLoad extends ChangeNotifier {
  int reloadNum = 0;

  void reLoad() {
    reloadNum++;
    notifyListeners();
  }
}
