import 'package:flutter/material.dart';

// class AppTheme {
//   static final lightTheme = ThemeData(
//       scaffoldBackgroundColor: Colors.white,
//       primaryColor: const Color.fromARGB(255, 17, 42, 64),
//       textTheme: const TextTheme(
//           titleLarge: TextStyle(
//               fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
//           titleMedium: TextStyle(
//               fontSize: 18.0,
//               color: Colors.black,
//               fontWeight: FontWeight.normal)));
//   static final darkTheme = ThemeData(
//       scaffoldBackgroundColor: Colors.black,
//       primaryColor: const Color.fromARGB(255, 17, 42, 64),
//       textTheme: const TextTheme(
//           titleLarge: TextStyle(
//               fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
//           titleMedium: TextStyle(
//               fontSize: 18.0,
//               color: Colors.white,
//               fontWeight: FontWeight.normal)));
// }

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: const Color.fromARGB(255, 17, 42, 64),
    brightness: Brightness.light,
    // Define other light theme properties here
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: const Color.fromARGB(255, 17, 42, 64),
    brightness: Brightness.dark,
    // Define other dark theme properties here
  );
}
