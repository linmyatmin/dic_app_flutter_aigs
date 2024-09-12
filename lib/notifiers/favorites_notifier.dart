import 'package:dic_app_flutter/models/word_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<List<Word>> {
  FavoritesNotifier() : super([]);

  void addFavorite(Word word) {
    if (!state.contains(word)) {
      state = [...state, word];
    }
  }

  void removeFavorite(Word word) {
    state = state.where((w) => w != word).toList();
  }

  bool isFavorite(Word word) {
    return state.contains(word);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Word>>((ref) {
  return FavoritesNotifier();
});
