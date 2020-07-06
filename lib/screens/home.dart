import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile.dart';
import 'saved.dart';
import 'package:entangle/signin.dart';

int _currentindex = 0;

WillPopScope bottomNavigate(WillPopScope sem, BuildContext context) {
  WillPopScope tabs(int index, WillPopScope semTab) {
    if (index == 0) return semTab;
    if (index == 1) return save(context);
  }

  return WillPopScope(
    onWillPop: () => SystemNavigator.pop(),
    child: Scaffold(
      body: tabs(_currentindex, sem),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.indigo,
        currentIndex: _currentindex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(size: 25),
        unselectedIconTheme: IconThemeData(size: 20),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: (_currentindex != 1)
                ? Icon(Icons.bookmark_border)
                : Icon(Icons.bookmark),
            title: Text('Saved'),
          ),
        ],
        onTap: (index) {
          _currentindex = index;
        },
      ),
    ),
  );
}
