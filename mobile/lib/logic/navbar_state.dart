import 'package:flutter/material.dart';

class NavBarState with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (index == 1){
      _selectedIndex = 0;
    } else {
      _selectedIndex = index;
    }
    notifyListeners();
  }
}
