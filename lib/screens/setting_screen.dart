import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dic_app_flutter/providers/font_size_provider.dart'; // Import the font size provider
import 'package:dic_app_flutter/providers/theme_provider.dart'; // Import theme provider

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider); // Watch the current theme mode
    final isDarkMode = themeMode == ThemeMode.dark;

    // Watch the current font size from the provider
    final fontSize = ref.watch(fontSizeProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Dark mode switch
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontSize: 12.0),
              ),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (bool value) {
                  ref
                      .read(themeProvider.notifier)
                      .toggleTheme(value); // Update theme mode
                },
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            ),
            const SizedBox(height: 10),
            // Font size slider
            ListTile(
              leading: const Icon(Icons.font_download),
              subtitle: Slider(
                min: 10.0,
                max: 30.0,
                divisions: 10,
                value: fontSize,
                label: fontSize.round().toString(),
                onChanged: (newSize) {
                  // Update the font size using the provider
                  ref.read(fontSizeProvider.notifier).updateFontSize(newSize);
                },
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            ),
          ],
        ),
      ),
    );
  }
}
