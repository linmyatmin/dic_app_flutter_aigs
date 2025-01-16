import 'dart:convert';

import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:dic_app_flutter/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<List<Word>> {
  final SecureStorageService _secureStorage = SecureStorageService();
  final Ref ref;

  FavoritesNotifier(this.ref) : super([]) {
    _loadFavorites(); // Load the saved favorites when the notifier is initialized
  }

  Future<void> _loadFavorites() async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      state = []; // Empty state if not authenticated
      return;
    }

    try {
      final favorites = await _secureStorage.getFavorites();
      if (favorites != null) {
        state = favorites
            .map((jsonWord) => Word.fromJson(jsonDecode(jsonWord)))
            .toList();
      }
    } catch (e) {
      print('Error loading favorites: $e');
      state = [];
    }
  }

  bool isFavorite(Word? word) {
    if (word == null) return false;
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) return false;
    return state.any((w) => w.id == word.id); // Compare by ID
  }

  Future<void> addFavorite(Word word) async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      throw Exception('Please login to add favorites');
    }

    if (!state.any((w) => w.id == word.id)) {
      // Compare by ID
      state = [...state, word];
      await _saveFavorites();
    }
  }

  Future<void> removeFavorite(Word word) async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) return;

    state = state.where((w) => w.id != word.id).toList(); // Compare by ID
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final List<String> encodedWords =
        state.map((word) => jsonEncode(word.toJson())).toList();
    await _secureStorage.saveFavorites(encodedWords);
  }

  void clearFavorites() {
    state = [];
    _secureStorage.deleteFavorites();
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Word>>((ref) {
  return FavoritesNotifier(ref);
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
