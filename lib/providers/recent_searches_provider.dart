// First, create this provider file
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kRecentSearchesKey = 'recent_searches';
const int _maxRecentSearches = 5; // Reduced to 5 for better UI in home screen

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  final SharedPreferences prefs;

  RecentSearchesNotifier(this.prefs) : super([]) {
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    final searches = prefs.getStringList(_kRecentSearchesKey) ?? [];
    state = searches;
  }

  Future<void> addSearch(String query) async {
    if (query.trim().isEmpty) return;

    final searches = [...state];
    searches.remove(query);
    searches.insert(0, query);
    if (searches.length > _maxRecentSearches) {
      searches.removeLast();
    }

    state = searches;
    await prefs.setStringList(_kRecentSearchesKey, searches);
  }

  Future<void> removeSearch(String query) async {
    final searches = [...state];
    searches.remove(query);
    state = searches;
    await prefs.setStringList(_kRecentSearchesKey, searches);
  }

  Future<void> clearSearches() async {
    state = [];
    await prefs.remove(_kRecentSearchesKey);
  }
}
