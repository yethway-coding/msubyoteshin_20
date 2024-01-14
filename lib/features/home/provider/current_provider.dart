import 'package:flutter/material.dart';

class CurrentProvider extends ChangeNotifier {
  int _currentTab = 0;
  int _currentPage = 0;
  bool _isFocusOnTab = true;
  int get currentTab => _currentTab;
  int get currentPage => _currentPage;
  bool get isFocusOnTab => _isFocusOnTab;

  void changeCurrentTab(int currentTab) {
    _currentTab = currentTab;
    notifyListeners();
  }

  void changFocusOnTab() {
    _isFocusOnTab = !_isFocusOnTab;
    notifyListeners();
  }

  void changeCurrentPage(int currentPage) {
    _currentPage = currentPage;
    notifyListeners();
  }
}
