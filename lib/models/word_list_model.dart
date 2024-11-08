import 'dart:convert';
import 'package:dic_app_flutter/models/word_model.dart';

class ResWord {
  late List<Word> words;

  ResWord({required this.words});

  factory ResWord.fromRawJson(String str) => ResWord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  // Modify this method to handle a list directly
  factory ResWord.fromJson(List<dynamic> json) => ResWord(
        words: List<Word>.from(json.map((x) => Word.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "words": List<dynamic>.from(words.map((x) => x.toJson())),
      };
}

// class ResWord {
//   late List<Word> words;

//   ResWord({required this.words});

//   factory ResWord.fromRawJson(String str) => ResWord.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory ResWord.fromJson(Map<String, dynamic> json) => ResWord(
//         words: List<Word>.from(json["data"].map((x) => Word.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "words": List<dynamic>.from(words.map((x) => x.toJson())),
//       };
// }
