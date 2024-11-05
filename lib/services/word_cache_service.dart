import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_model.dart';

class WordCacheService {
  static const String _cacheKey = 'cached_words';
  static const String _timestampKey = 'words_cache_timestamp';

  Future<void> cacheWords(List<Word> words) async {
    final prefs = await SharedPreferences.getInstance();
    final wordsJson = words.map((word) => word.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(wordsJson));
    await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<DateTime?> getLastCacheTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_timestampKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  // Optional: Add method to check if cache is stale
  Future<bool> isCacheStale() async {
    final lastCacheTime = await getLastCacheTime();
    if (lastCacheTime == null) return true;

    final staleThreshold = Duration(hours: 24); // Adjust as needed
    return DateTime.now().difference(lastCacheTime) > staleThreshold;
  }

  Future<List<Word>?> getCachedWords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedData = prefs.getString(_cacheKey);

      if (cachedData == null) {
        print('No cached words found');
        return null;
      }

      final List<dynamic> wordsJson = jsonDecode(cachedData);
      final words = wordsJson.map((json) => Word.fromJson(json)).toList();
      print('Loaded ${words.length} words from cache');
      return words;
    } catch (e) {
      print('Error loading cached words: $e');
      return null;
    }
  }

  // Add this method to clear cache for testing
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
