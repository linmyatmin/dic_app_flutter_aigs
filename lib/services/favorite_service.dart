import 'package:shared_preferences/shared_preferences.dart';

class FavoriteManager {
  static const String favoriteKey = 'favorites';

  Future<List<String>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(favoriteKey) ?? [];
  }

  Future<void> addFavorite(String itemId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(favoriteKey) ?? [];
    if (!favorites.contains(itemId)) {
      favorites.add(itemId);
      await prefs.setStringList(favoriteKey, favorites);
    }
  }

  Future<void> removeFavorite(String itemId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(favoriteKey) ?? [];
    favorites.remove(itemId);
    await prefs.setStringList(favoriteKey, favorites);
  }

  Future<bool> isFavorite(String itemId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(favoriteKey) ?? [];
    return favorites.contains(itemId);
  }
}
