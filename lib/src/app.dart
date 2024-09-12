import 'package:dic_app_flutter/screens/home_screen.dart';
import 'package:dic_app_flutter/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'GEMPEDIA',
      debugShowCheckedModeBanner: false,
      // home: authState.member != null ? HomeScreen() : LoginScreen(),
      home: HomeScreen(),
      // home: Consumer<UserProvider>(
      //   builder: (context, userProvider, child) {
      //     // Check if the user is logged in and show the appropriate screen
      //     if (userProvider.user != null) {
      //       return HomeScreen();
      //     } else {
      //       return LoginScreen();
      //     }
      //   },
      // ),
      // theme: appTheme(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
    );
  }
}
