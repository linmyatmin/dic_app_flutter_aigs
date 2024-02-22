import 'dart:convert';
import 'package:dic_app_flutter/models/product_model.dart';
import 'package:dic_app_flutter/models/res_product_model.dart';
import 'package:dic_app_flutter/models/user_model.dart';
import 'package:http/http.dart' as http;

class API {
  // final String _baseUrl = "https://jsonplaceholder.typicode.com";
  final String _baseUrl = "https://dummyjson.com";
  // final String _baseUrl = "https://fakestoreapi.com";

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse("$_baseUrl/users"));

    if (response.statusCode == 200) {
      var jsonResp = json.decode(response.body);

      List<User> users =
          List<User>.from(jsonResp.map((user) => User.fromJson(user)));

      return users;
    } else {
      throw Exception('Failed to load users!');
    }
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse("$_baseUrl/products"));

    if (response.statusCode == 200) {
      var jsonResp = ResProduct.fromRawJson(response.body);

      // var jsonResp = json.decode(response.body);
      // List<Product> products = List<Product>.from(
      //     jsonResp.products.map((product) => Product.fromJson(product)));

      return jsonResp.products;
    } else {
      throw Exception('Failed to load products!');
    }
  }

  Future<List<Product>> searchProducts(String searchValue) async {
    final response =
        await http.get(Uri.parse("$_baseUrl/products/search?q=$searchValue"));

    if (response.statusCode == 200) {
      var jsonResp = ResProduct.fromRawJson(response.body);

      // var jsonResp = json.decode(response.body);
      // List<Product> products = List<Product>.from(
      //     jsonResp.products.map((product) => Product.fromJson(product)));

      return jsonResp.products;
    } else {
      throw Exception('Failed to search products!');
    }
  }
}
