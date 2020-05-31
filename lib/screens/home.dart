import 'package:flutter/material.dart';
import 'profile.dart';
import 'saved.dart';

int _currentindex = 0;
Scaffold tabs(int index, Scaffold semTab) {
  if (index == 0) return semTab;
  if (index == 1) return save();
  if (index == 2) return profile();
}

Scaffold bottomNavigate(Scaffold sem) {
  return Scaffold(
    body: tabs(_currentindex, sem),
    bottomNavigationBar: BottomNavigationBar(
      unselectedItemColor: Colors.blueGrey,
      selectedItemColor: Colors.indigo,
      currentIndex: _currentindex,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedLabelStyle: TextStyle(fontSize: 10),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          title: Text('Saved'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), title: Text('Profile')),
      ],
      onTap: (index) {
        _currentindex = index;
      },
    ),
  );
}
