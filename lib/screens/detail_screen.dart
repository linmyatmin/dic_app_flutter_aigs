import 'package:dic_app_flutter/components/word_detail.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/notifiers/favorites_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailScreen extends ConsumerWidget {
  final Word? word;

  const DetailScreen({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(word);

    return Scaffold(
        // backgroundColor: const Color.fromARGB(255, 48, 148, 34),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            word!.nameEn,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (isFavorite) {
                    ref.read(favoritesProvider.notifier).removeFavorite(word!);
                  } else {
                    ref.read(favoritesProvider.notifier).addFavorite(word!);
                  }
                },
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border))
          ],
        ),
        body: WordDetail(word: word));
  }
}
