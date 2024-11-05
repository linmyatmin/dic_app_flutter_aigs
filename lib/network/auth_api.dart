import 'dart:convert';
import 'package:dic_app_flutter/models/member.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class AuthAPI {
  final Dio _dio = Dio();
  // final String _baseUrl = "https://dummyjson.com";
  // final String _baseUrl = "http://192.168.9.144";
  final String _baseUrl = "https://localhost:44378";
  final String _baseUrlProduction = "http://122.155.9.144";

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response =
        await _dio.post('$_baseUrlProduction/api/auth/signin', data: {
      'Email': username,
      'Password': password,
    });
    print('authAPI_LOGIN: ${response.data}');
    return response.data;
  }

  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final response =
        await _dio.post('$_baseUrlProduction/api/auth/signup', data: {
      'username': username,
      'email': email,
      'password': password,
    });
    return response.data;
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
