import 'package:dic_app_flutter/screens/home_screen.dart';
import 'package:dic_app_flutter/theme/app_theme.dart';
import 'package:dic_app_flutter/theme/style.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DicApp',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      // theme: appTheme(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // darkTheme: ThemeData(
      //     brightness: Brightness.dark,
      //     scaffoldBackgroundColor: Colors.redAccent,
      //     primaryColor: Colors.orangeAccent),
    );
  }
}
