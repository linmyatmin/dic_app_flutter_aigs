import 'package:dic_app_flutter/components/word_detail.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:dic_app_flutter/notifiers/favorites_notifier.dart';
import 'package:dic_app_flutter/providers/font_size_provider.dart'; // Import the font size provider
import 'package:dic_app_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailScreen extends ConsumerWidget {
  final Word? word;

  const DetailScreen({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final favorites = ref.watch(favoritesProvider);
    final isFavorite =
        authState.isAuthenticated && favorites.any((w) => w.id == word?.id);
    final fontSize = ref.watch(fontSizeProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        // title: Text(
        //   word!.nameEn!.replaceAll(RegExp(r'<\/?p>'), ''),
        //   style: const TextStyle(color: Colors.white),
        // ),
        title: Html(
          data: word?.nameEn,
          style: {"p": Style(color: Colors.white)},
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (!authState.isAuthenticated) {
                // Show login prompt
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please login to add favorites'),
                    action: SnackBarAction(
                      label: 'Login',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                    ),
                  ),
                );
                return;
              }

              if (isFavorite) {
                ref.read(favoritesProvider.notifier).removeFavorite(word!);
              } else {
                ref.read(favoritesProvider.notifier).addFavorite(word!);
              }
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Font size slider with improved design
          Container(
            color: const Color.fromARGB(255, 45, 66, 87),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Text Size",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Slider(
                    min: 10.0,
                    max: 30.0,
                    divisions: 10,
                    value: fontSize,
                    activeColor: Colors.white,
                    onChanged: (newSize) {
                      ref
                          .read(fontSizeProvider.notifier)
                          .updateFontSize(newSize);
                    },
                  ),
                ),
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    fontSize.round().toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Word detail component
          Expanded(
            child: WordDetail(
              word: word,
              textSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
