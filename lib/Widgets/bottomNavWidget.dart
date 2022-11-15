import 'package:flutter/material.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';

Widget myBottomNav(int _selectedIndex, List<BottomNavigationBarItem> btmItem,
    _itemTaped(int value)) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: _selectedIndex,
    items: ConstantsVar.btmItem,
    onTap: _itemTaped,
  );
}
