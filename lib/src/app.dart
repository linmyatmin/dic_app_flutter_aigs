import 'package:dic_app_flutter/screens/home_screen.dart';
import 'package:dic_app_flutter/theme/app_theme.dart';
import 'package:dic_app_flutter/providers/theme_provider.dart'; // Import the theme provider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider); // Watch the theme provider

    return MaterialApp(
      title: 'GEMPEDIA',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(), // Default home screen
      theme: AppTheme.lightTheme, // Define your light theme
      darkTheme: AppTheme.darkTheme, // Define your dark theme
      themeMode: themeMode, // Use the current theme mode from the provider
    );
  }
}
