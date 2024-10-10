import 'dart:convert';
import 'package:dic_app_flutter/models/word_list_model.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:http/http.dart' as http;

class API {
  // final String _baseUrl = "https://jsonplaceholder.typicode.com";
  final String _baseUrl = "https://api.aigsthailand.com/api";
  // final String _baseUrl = "https://fakestoreapi.com";

  // Future<List<User>> getUsers() async {
  //   final response = await http.get(Uri.parse("$_baseUrl/users"));

  //   if (response.statusCode == 200) {
  //     var jsonResp = json.decode(response.body);

  //     List<User> users =
  //         List<User>.from(jsonResp.map((user) => User.fromJson(user)));

  //     return users;
  //   } else {
  //     throw Exception('Failed to load users!');
  //   }
  // }

  // Future<List<Product>> getProducts() async {
  //   final response = await http.get(Uri.parse("$_baseUrl/products"));

  //   if (response.statusCode == 200) {
  //     var jsonResp = ResProduct.fromRawJson(response.body);

  //     // var jsonResp = json.decode(response.body);
  //     // List<Product> products = List<Product>.from(
  //     //     jsonResp.products.map((product) => Product.fromJson(product)));

  //     return jsonResp.products;
  //   } else {
  //     throw Exception('Failed to load products!');
  //   }
  // }

  // Future<List<Product>> searchProducts(String searchValue) async {
  //   final response =
  //       await http.get(Uri.parse("$_baseUrl/products/search?q=$searchValue"));

  //   if (response.statusCode == 200) {
  //     var jsonResp = ResProduct.fromRawJson(response.body);

  //     // var jsonResp = json.decode(response.body);
  //     // List<Product> products = List<Product>.from(
  //     //     jsonResp.products.map((product) => Product.fromJson(product)));

  //     return jsonResp.products;
  //   } else {
  //     throw Exception('Failed to search products!');
  //   }
  // }

  Future<List<Word>> getWords() async {
    final response = await http.get(Uri.parse("$_baseUrl/words"));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonResp = ResWord.fromRawJson(response.body);

      return jsonResp.words;
    } else {
      throw Exception('Failed to load words!');
    }
  }

  // Future<List<Word>> searchWords(String searchValue) async {
  //   final String response =
  //       await rootBundle.loadString('assets/sample_data.json');
  //   var jsonResp = ResWord.fromRawJson(response);

  //   // Filtering words based on search value
  //   List<Word> filteredWords = jsonResp.words.where((word) {
  //     return word.nameEn!.toLowerCase().contains(searchValue.toLowerCase());
  //   }).toList();

  //   return filteredWords;
  // }

  // Future<List<Word>> getWordDetailById(id) async {
  //   final response = await http.get(Uri.parse("$_baseUrl/words/$id"));

  //   print(response.statusCode);
  //   print(response.body);

  //   if (response.statusCode == 200) {
  //     var jsonResp = ResWord.fromRawJson(response.body);

  //     return jsonResp.words;
  //   } else {
  //     throw Exception('Failed to load word!');
  //   }
  // }

  Future<List<Word>> getWordDetailById(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/words/$id"));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonResp = json.decode(response.body);

      if (jsonResp is Map<String, dynamic>) {
        // Handle the case where it's a single word object
        return [
          Word.fromJson(jsonResp['data'])
        ]; // Make sure to access the 'data' field
      } else {
        throw Exception('Unexpected response format!');
      }
    } else {
      throw Exception('Failed to load word details!');
    }
  }
}
