import 'package:house/importLib.dart';

class ProviderHouseReLoad extends ChangeNotifier {
  int reloadNum = 0;

  void reLoad() {
    reloadNum++;
    notifyListeners();
  }
}
