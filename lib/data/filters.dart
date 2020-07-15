import 'package:flutter/foundation.dart';

class Filters extends ChangeNotifier {
  Filters();

  String _search = "";

  String get search {
    return _search;
  }

  void updateSearch(String search) {
    if (_search != search) {
      _search = search;
      notifyListeners();
    }
  }

  void clearSearch() {
    if (_search != "") {
      _search = "";
      notifyListeners();
    }
  }
}
