import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSettings {
  final Map<String, bool> enabledLanguages;

  LanguageSettings({required this.enabledLanguages});
}

class LanguageSettingsNotifier extends StateNotifier<LanguageSettings> {
  LanguageSettingsNotifier()
      : super(LanguageSettings(enabledLanguages: {
          'GB': true, // English is always enabled
          // 'TH': true,
          // 'CN': true,
          // 'FR': true,
          // 'ES': true,
          // 'JP': true,
          'TH': false, // Disable other languages
          'CN': false,
          'FR': false,
          'ES': false,
          'JP': false,
        }));

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, bool> savedSettings = {
      'GB': true, // English is always true
      //   'TH': prefs.getBool('lang_TH') ?? true,
      // 'CN': prefs.getBool('lang_CN') ?? true,
      // 'FR': prefs.getBool('lang_FR') ?? true,
      // 'ES': prefs.getBool('lang_ES') ?? true,
      // 'JP': prefs.getBool('lang_JP') ?? true,
      'TH': prefs.getBool('lang_TH') ?? false, // Default to false
      'CN': prefs.getBool('lang_CN') ?? false,
      'FR': prefs.getBool('lang_FR') ?? false,
      'ES': prefs.getBool('lang_ES') ?? false,
      'JP': prefs.getBool('lang_JP') ?? false,
    };
    state = LanguageSettings(enabledLanguages: savedSettings);
  }

  Future<void> toggleLanguage(String langCode) async {
    if (langCode == 'GB') return; // Prevent toggling English

    // final prefs = await SharedPreferences.getInstance();
    // final newSettings = Map<String, bool>.from(state.enabledLanguages);
    // newSettings[langCode] = !newSettings[langCode]!;

    // await prefs.setBool('lang_$langCode', newSettings[langCode]!);
    // state = LanguageSettings(enabledLanguages: newSettings);
    // Disable toggling other languages
    return;
  }
}

final languageSettingsProvider =
    StateNotifierProvider<LanguageSettingsNotifier, LanguageSettings>((ref) {
  return LanguageSettingsNotifier();
});
