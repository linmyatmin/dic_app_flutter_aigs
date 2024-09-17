import 'package:dic_app_flutter/models/word_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For encoding and decoding JSON

class FavoritesNotifier extends StateNotifier<List<Word>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites(); // Load the saved favorites when the notifier is initialized
  }

  // Key for SharedPreferences
  static const _favoritesKey = 'favorites';

  // Add favorite and persist the change
  void addFavorite(Word word) {
    if (!state.contains(word)) {
      state = [...state, word];
      _saveFavorites(); // Save the updated favorites
    }
  }

  // Remove favorite and persist the change
  void removeFavorite(Word word) {
    state = state.where((w) => w != word).toList();
    _saveFavorites(); // Save the updated favorites
  }

  bool isFavorite(Word word) {
    return state.contains(word);
  }

  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString(_favoritesKey);
    if (favoritesString != null) {
      final List<dynamic> decodedFavorites = jsonDecode(favoritesString);
      state =
          decodedFavorites.map((jsonWord) => Word.fromJson(jsonWord)).toList();
    }
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString =
        jsonEncode(state.map((word) => word.toJson()).toList());
    await prefs.setString(_favoritesKey, favoritesString);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Word>>((ref) {
  return FavoritesNotifier();
});


// import 'package:dic_app_flutter/models/word_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class FavoritesNotifier extends StateNotifier<List<Word>> {
//   FavoritesNotifier() : super([]);

//   void addFavorite(Word word) {
//     if (!state.contains(word)) {
//       state = [...state, word];
//     }
//   }

//   void removeFavorite(Word word) {
//     state = state.where((w) => w != word).toList();
//   }

//   bool isFavorite(Word word) {
//     return state.contains(word);
//   }
// }

// final favoritesProvider =
//     StateNotifierProvider<FavoritesNotifier, List<Word>>((ref) {
//   return FavoritesNotifier();
// });
