import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dic_app_flutter/providers/font_size_provider.dart'; // Import the font size provider
import 'package:dic_app_flutter/providers/theme_provider.dart'; // Import theme provider
import 'package:intl/intl.dart';
import '../services/word_cache_service.dart';
import '../network/api.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Add this import
import 'package:dic_app_flutter/providers/language_settings_provider.dart'; // Import language settings provider
import 'package:dic_app_flutter/screens/login_screen.dart';
import 'package:dic_app_flutter/providers/auth_provider.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  final WordCacheService _cacheService = WordCacheService();
  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _loadLastSyncTime();
  }

  Future<void> _loadLastSyncTime() async {
    final timestamp = await _cacheService.getLastCacheTime();
    setState(() {
      _lastSyncTime = timestamp;
    });
  }

  Future<void> _syncData() async {
    // Check internet connection first
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'No internet connection. Please check your connection and try again.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    setState(() {
      _isSyncing = true;
    });

    try {
      // Add timeout to API call
      final api = API();
      final newWords = await api.getWords().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw 'Connection timed out. Please check your internet connection.';
        },
      );

      await _cacheService.cacheWords(newWords);
      await _loadLastSyncTime();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dictionary data synchronized successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Failed to sync data. ';
        if (e.toString().contains('SocketException') ||
            e.toString().contains('Connection refused') ||
            e.toString().contains('timed out')) {
          errorMessage =
              'No internet connection. Please check your connection and try again.';
        } else {
          errorMessage += e.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final fontSize = ref.watch(fontSizeProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: isDarkMode
          ? Theme.of(context).primaryColorLight
          : Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Data Sync Card
                  _buildSettingsCard(
                    title: 'Data Synchronization',
                    icon: Icons.sync,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      // leading: Container(
                      //   padding: const EdgeInsets.all(8),
                      //   decoration: BoxDecoration(
                      //     color: isDarkMode
                      //         ? Colors.white.withOpacity(0.1)
                      //         : Theme.of(context).primaryColor.withOpacity(0.1),
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      //   child: Icon(
                      //     Icons.sync,
                      //     color: isDarkMode
                      //         ? Colors.white
                      //         : Theme.of(context).primaryColor,
                      //   ),
                      // ),
                      title: const Text('Sync Dictionary Data'),
                      subtitle: _lastSyncTime != null
                          ? Text(
                              'Last synced: ${DateFormat('MMM d, y HH:mm').format(_lastSyncTime!)}')
                          : const Text('Never synced'),
                      trailing: _isSyncing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.refresh,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ),
                      onTap: _isSyncing ? null : _syncData,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Display Settings Card
                  _buildSettingsCard(
                    title: 'Display',
                    icon: Icons.palette,
                    child: Column(
                      children: [
                        // Dark mode switch
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.1)
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.dark_mode,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text('Dark Mode'),
                            ],
                          ),
                          value: isDarkMode,
                          onChanged: (value) {
                            ref.read(themeProvider.notifier).toggleTheme(value);
                          },
                        ),
                        const Divider(),
                        // Font size section
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Colors.white.withOpacity(0.1)
                                          : Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.format_size,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Font Size (${fontSize.round()})',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text('A',
                                      style: TextStyle(fontSize: 12)),
                                  Expanded(
                                    child: Slider(
                                      min: 10.0,
                                      max: 30.0,
                                      divisions: 20,
                                      value: fontSize,
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      onChanged: (newSize) {
                                        ref
                                            .read(fontSizeProvider.notifier)
                                            .updateFontSize(newSize);
                                      },
                                    ),
                                  ),
                                  const Text('A',
                                      style: TextStyle(fontSize: 24)),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.05)
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Preview Text',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'This is how your text will look with the current font size.',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Language Settings Card
                  _buildSettingsCard(
                    title: 'Language',
                    icon: Icons.language,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final languageSettings =
                            ref.watch(languageSettingsProvider);
                        return Column(
                          children: languageSettings.enabledLanguages.entries
                              .map((entry) {
                            final bool isEnglish = entry.key == 'GB';
                            return SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.asset(
                                      'icons/flags/png100px/${entry.key.toLowerCase()}.png',
                                      package: 'country_icons',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    _getLanguageName(entry.key),
                                    style: TextStyle(
                                      color: isEnglish ? Colors.grey : null,
                                    ),
                                  ),
                                ],
                              ),
                              value: entry.value,
                              onChanged: isEnglish
                                  ? null
                                  : (bool value) {
                                      ref
                                          .read(
                                              languageSettingsProvider.notifier)
                                          .toggleLanguage(entry.key);
                                    },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sign Out Button (only show if authenticated)
                  if (authState.isAuthenticated)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final authService = ref.read(authServiceProvider);
                          await authService.signOut();
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Sign Out'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: isDark ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Container(
                //   padding: const EdgeInsets.all(8),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).primaryColor.withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Icon(
                //     icon,
                //     color: Theme.of(context).primaryColor,
                //     size: 20,
                //   ),
                // ),
                // const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'GB':
        return 'English';
      case 'TH':
        return 'Thai';
      case 'CN':
        return 'Chinese';
      case 'FR':
        return 'French';
      case 'ES':
        return 'Spanish';
      case 'JP':
        return 'Japanese';
      default:
        return code;
    }
  }
}
