import 'package:entangle/screens/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'saved.dart';
import 'package:entangle/main.dart';

int _currentindex = 0;

WillPopScope bottomNavigate(WillPopScope sem, BuildContext context) {
  WillPopScope tabs(int index, WillPopScope semTab) {
    if (index == 0) return semTab;
    if (index == 1)
      return WillPopScope(child: Search_screen(), onWillPop: null);
    if (index == 2) return save(context);
  }

  return WillPopScope(
    onWillPop: () => SystemNavigator.pop(),
    child: Scaffold(
      body: tabs(_currentindex, sem),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: maincolor,
        selectedLabelStyle: TextStyle(color: maincolor),
        unselectedLabelStyle: TextStyle(color: maincolor2),
        currentIndex: _currentindex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedIconTheme: IconThemeData(size: 25),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/entangle.png',
              scale: 25,
            ),
            title: Text('Home',
                style: TextStyle(color: Colors.grey, fontSize: 10)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(
              'Serach',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
          BottomNavigationBarItem(
            icon: (_currentindex != 2)
                ? Icon(Icons.bookmark_border)
                : Icon(Icons.bookmark),
            title: Text('Saved',
                style: TextStyle(color: Colors.grey, fontSize: 10)),
          ),
        ],
        onTap: (index) {
          _currentindex = index;
        },
      ),
    ),
  );
}
