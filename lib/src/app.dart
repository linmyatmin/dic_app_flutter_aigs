import 'package:dic_app_flutter/screens/home_screen.dart';
import 'package:dic_app_flutter/theme/style.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DicAppAigs',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: appTheme(),
    );
  }
}
