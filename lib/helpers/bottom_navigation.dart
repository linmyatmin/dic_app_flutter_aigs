import 'package:dic_app_flutter/screens/contactus_screen.dart';
import 'package:dic_app_flutter/screens/home_screen.dart';
import 'package:dic_app_flutter/screens/words_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final ValueChanged<int> onItemTapped;
  final int selectedIndex;

  const BottomNavigation(
      {required this.onItemTapped, required this.selectedIndex, super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.list),
        //   label: 'Words',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_rounded),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'About Us',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: widget.onItemTapped,
    );
  }
}
