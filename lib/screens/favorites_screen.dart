import 'package:dic_app_flutter/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dic_app_flutter/notifiers/favorites_notifier.dart';
import 'package:dic_app_flutter/providers/font_size_provider.dart'; // Import the font size provider

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    // final fontSize = ref.watch(fontSizeProvider); // Watch the font size

    return Scaffold(
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites added'))
          : ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final word = favorites[index];
                return Dismissible(
                  key: Key(word.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    ref.read(favoritesProvider.notifier).removeFavorite(word);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('${word.nameEn} removed from favorites')));
                  },
                  background: Container(
                    color: Colors.red[500],
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      word.nameEn,
                      style: const TextStyle(
                          fontSize:
                              12.0), // Use the font size from the provider
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(word: word),
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey[400],
                  height: 1,
                );
              },
            ),
    );
  }
}
