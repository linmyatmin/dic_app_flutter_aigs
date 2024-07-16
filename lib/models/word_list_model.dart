import 'dart:convert';
import 'package:dic_app_flutter/models/word_model.dart';

class ResWord {
  late List<Word> words;

  ResWord({required this.words});

  factory ResWord.fromRawJson(String str) => ResWord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResWord.fromJson(Map<String, dynamic> json) => ResWord(
        words: List<Word>.from(json["data"].map((x) => Word.fromJson(x))),
        // total: json["total"],
        // skip: json["skip"],
        // limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "words": List<dynamic>.from(words.map((x) => x.toJson())),
        // "total": total,
        // "skip": skip,
        // "limit": limit,
      };
}
