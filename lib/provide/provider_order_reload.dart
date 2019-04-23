import 'package:house/importLib.dart';

class ProviderOrderReLoad extends ChangeNotifier {
  int reloadNum = 0;

  void reLoad() {
    reloadNum++;
    notifyListeners();
  }
}
