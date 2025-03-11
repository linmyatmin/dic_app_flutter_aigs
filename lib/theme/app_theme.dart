import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF112A40);
  static const Color primaryColorLight = Color.fromARGB(255, 45, 66, 87);
  static const Color secondaryLight = Color(0x1A112A40); // 10% opacity
  static const Color secondaryDark = Color(0x1AFFFFFF); // 10% white

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    primaryColorLight: primaryColorLight,
    secondaryHeaderColor: secondaryDark,
    brightness: Brightness.light,
    scaffoldBackgroundColor: primaryColorLight,
    cardColor: Colors.white,
    shadowColor: Colors.grey.withOpacity(0.1),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      // backgroundColor: Colors.white,
      backgroundColor: primaryColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontSize: 20.0, color: primaryColor, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          fontSize: 18.0, color: primaryColor, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(color: primaryColor),
      bodySmall: TextStyle(color: Colors.grey),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    primaryColorLight: primaryColorLight,
    secondaryHeaderColor: secondaryDark,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Color(0xFF1C1C1E),
    shadowColor: Colors.black.withOpacity(0.2),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.grey),
    ),
  );
}
