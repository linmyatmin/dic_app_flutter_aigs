import 'package:flutter/material.dart';

ThemeData appTheme() => ThemeData(
      // primaryColor: Color(0xff242248),
      primaryColor: Color.fromARGB(255, 18, 139, 49),
      // accentColor: Color(0xff8468DD),
      canvasColor: Color.fromARGB(0, 80, 212, 109),
      primaryIconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(
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
