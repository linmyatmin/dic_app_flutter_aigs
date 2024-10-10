import 'package:dic_app_flutter/components/word_detail.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/notifiers/favorites_notifier.dart';
import 'package:dic_app_flutter/providers/font_size_provider.dart'; // Import the font size provider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailScreen extends ConsumerWidget {
  final Word? word;

  const DetailScreen({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(word);

    // Watch the current font size from the provider
    final fontSize = ref.watch(fontSizeProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          word!.nameEn!,
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
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border)),
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text("Font Size"),
          //       Slider(
          //         min: 10.0,
          //         max: 30.0,
          //         divisions: 10,
          //         value: fontSize,
          //         onChanged: (newSize) {
          //           // Update the font size using the provider
          //           ref.read(fontSizeProvider.notifier).updateFontSize(newSize);
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Container(
              color: Color.fromARGB(255, 45, 66, 87),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Text Size",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Slider(
                      min: 10.0,
                      max: 30.0,
                      divisions: 10,
                      value: fontSize,
                      onChanged: (newSize) {
                        ref
                            .read(fontSizeProvider.notifier)
                            .updateFontSize(newSize);
                      },
                    ),
                  ),
                  Text(
                    fontSize.toStringAsFixed(
                        1), // Display the font size with one decimal place
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Use the fontSize from the provider
          Expanded(
            child: WordDetail(word: word, textSize: fontSize),
          ),
        ],
      ),
    );
  }
}

// import 'package:dic_app_flutter/components/word_detail.dart';
// import 'package:dic_app_flutter/models/word_model.dart';
// import 'package:dic_app_flutter/notifiers/favorites_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DetailScreen extends ConsumerStatefulWidget {
//   final Word? word;

//   const DetailScreen({Key? key, required this.word}) : super(key: key);

//   @override
//   _DetailScreenState createState() => _DetailScreenState();
// }

// class _DetailScreenState extends ConsumerState<DetailScreen> {
//   double _textSize = 16.0; // Initial text size

//   @override
//   Widget build(BuildContext context) {
//     final favorites = ref.watch(favoritesProvider);
//     final isFavorite = favorites.contains(widget.word);

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: Theme.of(context).primaryColor,
//         title: Text(
//           widget.word!.nameEn,
//           style: const TextStyle(color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 if (isFavorite) {
//                   ref
//                       .read(favoritesProvider.notifier)
//                       .removeFavorite(widget.word!);
//                 } else {
//                   ref
//                       .read(favoritesProvider.notifier)
//                       .addFavorite(widget.word!);
//                 }
//               },
//               icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border))
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: WordDetail(word: widget.word, textSize: _textSize),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Font Size"),
//                 Slider(
//                   min: 10.0,
//                   max: 30.0,
//                   divisions: 10,
//                   value: _textSize,
//                   onChanged: (newSize) {
//                     setState(() {
//                       _textSize = newSize;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
