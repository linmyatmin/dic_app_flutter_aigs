import 'dart:convert';
import 'package:dic_app_flutter/models/subscription_plan_model.dart';
import 'package:dic_app_flutter/models/word_list_model.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dic_app_flutter/services/secure_storage_service.dart';

class API {
  final Dio _dio = Dio();
  // final String _baseUrl = "https://jsonplaceholder.typicode.com";
  final String _baseUrl = "https://api.aigsthailand.com/api";
  final String _baseUrl2 = "http://122.155.9.144/api";
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

  API() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final user = await SecureStorageService().getUser();
        if (user?.token != null) {
          options.headers['Authorization'] = 'Bearer ${user!.token}';
        }
        return handler.next(options);
      },
    ));
  }

  Future<List<Word>> getWords() async {
    final response = await http.get(Uri.parse("$_baseUrl2/words"));

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

  Future<List<Word>> getWordDetailById(int id) async {
    final response = await http.get(Uri.parse("$_baseUrl2/words/$id"));

    print(response.statusCode);
    print(response.body); // Log the entire response

    if (response.statusCode == 200) {
      var jsonResp = json.decode(response.body);

      if (jsonResp is Map<String, dynamic>) {
        // Directly return the Word object from the response
        return [Word.fromJson(jsonResp)]; // No need to access 'data'
      } else {
        throw Exception('Unexpected response format!');
      }
    } else {
      throw Exception('Failed to load word details!');
    }
  }

  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    final response = await http.get(Uri.parse("$_baseUrl2/subscriptionplans"));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonResp = json.decode(response.body);

      if (jsonResp is List) {
        return jsonResp.map((plan) => SubscriptionPlan.fromJson(plan)).toList();
      } else {
        throw Exception('Unexpected response format!');
      }
    } else {
      throw Exception('Failed to load subscription plans!');
    }
  }

  Future<void> verifyPurchase(
    String purchaseId,
    String verificationData,
    int planId,
  ) async {
    try {
      final response = await _dio.post(
        '/verify-purchase',
        data: {
          'purchase_id': purchaseId,
          'verification_data': verificationData,
          'plan_id': planId,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to verify purchase');
      }
    } catch (e) {
      throw Exception('Error verifying purchase: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw 'Login failed';
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? 'Login failed';
        throw errorMessage;
      }
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> createUserSubscription(
      String userId, int planId, String paymentId) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl2/UserSubscriptions/PostUserSubscription"),
        headers: {
          'Content-Type': 'application/json', // Set the content type
        },
        body: json.encode({
          'UserId': userId,
          'PlanId': planId,
          'PaymentIntentId': paymentId,
        }),
      );

      print(json.encode({
        'UserId': userId,
        'PlanId': planId,
        'PaymentIntentId': paymentId,
      }));

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.body}');

      // if (response.statusCode == 200) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body and return the subscription data
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to create subscription: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error creating subscription: $e');
    }
  }
}
