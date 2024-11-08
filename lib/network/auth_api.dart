import 'dart:convert';
import 'package:dic_app_flutter/models/member.dart';
import 'package:dic_app_flutter/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class AuthAPI {
  final Dio _dio = Dio();
  // final String _baseUrl = "https://dummyjson.com";
  // final String _baseUrl = "http://192.168.9.144";
  final String _baseUrl = "https://localhost:44378";
  final String _baseUrlProduction = "http://122.155.9.144";

  Future<UserModel> getUserData(String? userId, String? token) async {
    try {
      final response = await http.get(
        Uri.parse(
            "$_baseUrlProduction/api/auth/GetUserData/$userId"), // Adjust the endpoint as needed
        headers: {
          'Content-Type': 'application/json',
          // Add any necessary authentication headers here, e.g., 'Authorization': 'Bearer $token'
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final responseData = json.decode(response.body);

        // Check if the response indicates success
        if (responseData['success'] == true) {
          // Extract the user data
          final userData = responseData['data'];

          print(userData);

          return UserModel.fromJson(
              userData); // Assuming you have a User model with a fromJson method
        } else {
          throw Exception(
              'Failed to fetch user data: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Error fetching user data: $e');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response =
          await _dio.post('$_baseUrlProduction/api/auth/signin', data: {
        'Email': username,
        'Password': password,
      });

      print('Login response: ${response.data}');
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        print('Login error response: ${e.response?.data}');
        return e.response?.data ??
            {'success': false, 'message': 'Login failed', 'data': null};
      }
      throw {
        'success': false,
        'message': 'Network error occurred',
        'data': null
      };
    }
  }

  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrlProduction/api/auth/signup',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      // Print response for debugging
      print('Register response: ${response.data}');

      return response.data;
    } on DioError catch (e) {
      // Handle API error responses
      if (e.response != null) {
        print('Register error response: ${e.response?.data}');
        return e.response?.data ??
            {'success': false, 'message': 'Registration failed', 'data': null};
      }
      throw {
        'success': false,
        'message': 'Network error occurred',
        'data': null
      };
    }

    // final response =
    //     await _dio.post('$_baseUrlProduction/api/auth/signup', data: {
    //   'username': username,
    //   'email': email,
    //   'password': password,
    // });
    // return response.data;
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    // Implement Google Sign-In logic here
    // This should return the same format as the regular login
    return {};
  }
}


// fetch('https://dummyjson.com/auth/login', {
//   method: 'POST',
//   headers: { 'Content-Type': 'application/json' },
//   body: JSON.stringify({
    
//     username: 'kminchelle',
//     password: '0lelplR',
//     // expiresInMins: 60, // optional
//   })
// })
// .then(res => res.json())
// .then(console.log);




// {
//   "id": 15,
//   "username": "kminchelle",
//   "email": "kminchelle@qq.com",
//   "firstName": "Jeanne",
//   "lastName": "Halvorson",
//   "gender": "female",
//   "image": "https://robohash.org/Jeanne.png?set=set4",
//   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUsInVzZXJuYW1lIjoia21pbmNoZWxsZSIsImVtYWlsIjoia21pbmNoZWxsZUBxcS5jb20iLCJmaXJzdE5hbWUiOiJKZWFubmUiLCJsYXN0TmFtZSI6IkhhbHZvcnNvbiIsImdlbmRlciI6ImZlbWFsZSIsImltYWdlIjoiaHR0cHM6Ly9yb2JvaGFzaC5vcmcvYXV0cXVpYXV0LnBuZz9zaXplPTUweDUwJnNldD1zZXQxIiwiaWF0IjoxNjM1NzczOTYyLCJleHAiOjE2MzU3Nzc1NjJ9.n9PQX8w8ocKo0dMCw3g8bKhjB8Wo7f7IONFBDqfxKhs"
// }
