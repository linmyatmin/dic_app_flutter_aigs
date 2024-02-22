import 'package:dic_app_flutter/models/word_model.dart';

class WordsListModel {
  late List<WordModel> words;

  WordsListModel({required this.words});

  WordsListModel.fromJson(Map<String, dynamic> json) {
    // if (json['data'] != null) {
    if (json != null) {
      // words = new List<WordModel>();
      json['data'].forEach((v) {
        words.add(new WordModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.words != null) {
      data['data'] = this.words.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
