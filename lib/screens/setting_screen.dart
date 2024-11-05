import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dic_app_flutter/providers/font_size_provider.dart'; // Import the font size provider
import 'package:dic_app_flutter/providers/theme_provider.dart'; // Import theme provider
import 'package:intl/intl.dart';
import '../services/word_cache_service.dart';
import '../network/api.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Add this import

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Synchronization',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.sync,
                        color: isDarkMode
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
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
                          : Icon(
                              Icons.chevron_right,
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                      onTap: _isSyncing ? null : _syncData,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Display Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Dark mode switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.dark_mode,
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Dark Mode',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            ref.read(themeProvider.notifier).toggleTheme(value);
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    // Font size section
                    Row(
                      children: [
                        Icon(
                          Icons.format_size,
                          color: isDarkMode
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Font Size',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${fontSize.round()})',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('A', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: Slider(
                            min: 10.0,
                            max: 30.0,
                            divisions: 20,
                            value: fontSize,
                            label: fontSize.round().toString(),
                            onChanged: (newSize) {
                              ref
                                  .read(fontSizeProvider.notifier)
                                  .updateFontSize(newSize);
                            },
                          ),
                        ),
                        const Text('A', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    // Preview text
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preview Text',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This is how your text will look with the current font size.',
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
