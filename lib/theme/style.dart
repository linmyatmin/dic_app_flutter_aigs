import 'package:flutter/material.dart';

ThemeData appTheme() => ThemeData(
      brightness: Brightness.light,
      // primaryColor: Color(0xff242248),
      primaryColor: const Color.fromARGB(255, 17, 42, 64),
      scaffoldBackgroundColor: Colors.white,
      // accentColor: Color(0xff8468DD),
      canvasColor: const Color.fromARGB(0, 80, 212, 109),
      primaryIconTheme: const IconThemeData(color: Colors.black),
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.green,
          fontSize: 23,
        ),
        // body1: TextStyle(
        //   fontFamily: 'Sans',
        //   fontWeight: FontWeight.bold,
        //   color: Colors.white,
        //   fontSize: 18,
        // ),
        // body2: TextStyle(
        //   fontFamily: 'Sans',
        //   fontWeight: FontWeight.bold,
        //   color: Colors.white,
        //   fontSize: 16,
        // ),
        // caption: TextStyle(
        //   fontFamily: 'Sans',
        //   fontWeight: FontWeight.normal,
        //   color: Colors.white,
        //   fontSize: 14,
        // ),
      ),
    );
