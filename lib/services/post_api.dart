import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:dic_app_flutter/models/post.dart';
import 'package:dio/dio.dart';

final dio = Dio();

class PostApi {
  static Future<List<Post>> fetchPosts() async {
    // print('fetchPosts called...');

//     String data = await DefaultAssetBundle.of(context).loadString("assets/data.json");
// final jsonResult = jsonDecode(data);
    String data = await rootBundle.loadString('assets/data.json');
    final jsonResult = json.decode(data);
    // print(jsonResult);
    final posts = jsonResult.map((e) {
      print('_data: ${e}');
      return Post(
        userId: e['userId'],
        id: e['id'],
        title: e['title'],
        body: e['body'],
      );
    }).toList();
    // print(posts);
    // print('fetchPosts completed...');
    // return posts;
    // print(posts);
    return posts;

    // // const url = 'https://jsonplaceholder.typicode.com/posts/1';
    // // final uri = Uri.parse(url);
    // // // final response = await http.get(uri);
    // // final response = await dio.getUri(uri);
    // // debugPrint(response.data.toString());
    // // // print(response.data);
    // if (response.statusCode == 200) {
    //   if (response.data != null && response.data.isNotEmpty) {
    //     // final myJsonAsString =
    //     //     '{"userId": "1", "id": "1", "title":"1","body":"1"}';
    //     // final decoded = json.decode(myJsonAsString);
    //     // print(decoded);
    //     // print(response.body);
    //     // final List<dynamic> jsonData = jsonDecode(response.body);
    //     // final List<dynamic> jsonData = json.decode(response.body);
    //     final List<dynamic> jsonData = jsonDecode(response.data.toString());
    //     // print(jsonData[0]['title']);
    //     // final json = Post.fromJson(jsonData);
    //     // print('_jsonData: ${jsonData}');
    //     // print(json);
    //     // final results = json as List<dynamic>;
    //     // print('json_results: ${json['results']}');
    //     // print('json_results');
    //     // print(results);
    //     final posts = jsonData.map((e) {
    //       // print('_data: ${e}');
    //       return Post(
    //         userId: e['userId'],
    //         id: e['id'],
    //         title: e['title'],
    //         body: e['body'],
    //       );
    //     }).toList();
    //     print(posts);
    //     // print('fetchPosts completed...');
    //     // return posts;
    //     // print(posts);
    //     return posts;
    //   } else {
    //     throw Exception('Response body is null or empty');
    //   }
    // } else {
    //   throw Exception('Failed to load posts');
    // }
  }
}
