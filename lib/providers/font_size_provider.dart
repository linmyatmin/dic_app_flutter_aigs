import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// FontSizeNotifier that handles state and persistence
class FontSizeNotifier extends StateNotifier<double> {
  static const String _fontSizeKey = 'fontSize';
  FontSizeNotifier() : super(16.0) {
    _loadFontSize();
  }

  // Load saved font size from shared preferences
  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFontSize =
        prefs.getDouble(_fontSizeKey) ?? 16.0; // Default font size
    state = savedFontSize;
  }

  // Update font size and persist it
  Future<void> updateFontSize(double newSize) async {
    final prefs = await SharedPreferences.getInstance();
    state = newSize;
    await prefs.setDouble(_fontSizeKey, newSize);
  }
}

// Provider for FontSizeNotifier
final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>(
  (ref) => FontSizeNotifier(),
);
