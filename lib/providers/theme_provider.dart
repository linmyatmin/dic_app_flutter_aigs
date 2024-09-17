import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a provider to manage the theme mode
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const themeKey = 'themeMode';

  // Default theme mode-> ThemeMode.system
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(themeKey);

    if (theme != null) {
      state = theme == 'light' ? ThemeMode.light : ThemeMode.dark;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    state = mode;
    await prefs.setString(themeKey, mode == ThemeMode.light ? 'light' : 'dark');
  }

  void toggleTheme(bool isDarkMode) {
    setTheme(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
