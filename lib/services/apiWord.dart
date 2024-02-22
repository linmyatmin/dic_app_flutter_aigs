import 'package:dic_app_flutter/models/word_model.dart';
import "package:dio/dio.dart";

class ApiWord {
  final dio = Dio();

  Future<dynamic> getWord() async {
    final response =
        await dio.get('https://jsonplaceholder.typicode.com/posts');

    // print(response);
    return WordModel.fromJson(response.data);
  }
}
