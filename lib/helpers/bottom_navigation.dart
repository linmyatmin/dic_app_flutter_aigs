import 'package:dic_app_flutter/screens/contactus_screen.dart';
import 'package:dic_app_flutter/screens/home_screen.dart';
import 'package:dic_app_flutter/screens/words_screen.dart';
import 'package:flutter/material.dart';
import 'package:dic_app_flutter/theme/app_theme.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,
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
      // showSelectedLabels: false,
      // showUnselectedLabels: false,
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.withOpacity(0.5),
      selectedLabelStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      onTap: widget.onItemTapped,
    );
  }
}
