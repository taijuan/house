import 'package:house/importLib.dart';

class ProviderVendorReLoad extends ChangeNotifier {
  int reloadNum = 0;

  void reLoad() {
    reloadNum++;
    notifyListeners();
  }
}
