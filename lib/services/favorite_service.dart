import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:dic_app_flutter/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteManager {
  static const String favoriteKey = 'favorites';
  final SecureStorageService _secureStorage = SecureStorageService();
  final Ref ref;

  FavoriteManager(this.ref);

  Future<List<String>> getFavorites() async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      return [];
    }

    final favorites = await _secureStorage.getFavorites();
    return favorites ?? [];
  }

  Future<void> addFavorite(String itemId) async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      throw Exception('Please login to add favorites');
    }

    final List<String> favorites = await getFavorites();
    if (!favorites.contains(itemId)) {
      favorites.add(itemId);
      await _secureStorage.saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String itemId) async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      return;
    }

    final List<String> favorites = await getFavorites();
    favorites.remove(itemId);
    await _secureStorage.saveFavorites(favorites);
  }

  Future<bool> isFavorite(String itemId) async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      return false;
    }

    final List<String> favorites = await getFavorites();
    return favorites.contains(itemId);
  }

  Future<void> clearFavorites() async {
    await _secureStorage.deleteFavorites();
  }
}

// Add a provider for FavoriteManager
final favoriteManagerProvider = Provider((ref) => FavoriteManager(ref));
