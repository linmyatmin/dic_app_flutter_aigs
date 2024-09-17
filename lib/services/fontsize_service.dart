import 'package:shared_preferences/shared_preferences.dart';

class FontSizeManager {
  static const String fontSizeKey = 'fontSize';

  Future<double> getFontSize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(fontSizeKey) ?? 16.0; // Default font size
  }

  Future<void> setFontSize(double fontSize) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(fontSizeKey, fontSize);
  }
}
