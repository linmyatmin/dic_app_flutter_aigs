import 'dart:convert';
import 'package:dic_app_flutter/models/member.dart';
import 'package:http/http.dart' as http;

class AuthAPI {
  // final String _baseUrl = "https://dummyjson.com";
  // final String _baseUrl = "http://192.168.9.144";
  final String _baseUrl = "https://localhost:44378";

  Future<dynamic> login(String username, String password) async {
    try {
      // username = 'emilys';
      // password = 'emilyspass';

      final url = Uri.parse('$_baseUrl/api/auth/signin');
      // final url = Uri.parse('$_baseUrl/auth/login');

      print(
          'Login attempt with username: $username, password: $password, url: $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('login_auth_api status code: ${response.statusCode}');
      print('login_auth_api body: ${response.body}');

      if (response.statusCode == 200) {
        // Assuming the response body is in JSON format
        return jsonDecode(response.body);
      } else {
        // Handle different HTTP status codes
        return {
          'status': response.statusCode,
          'message': 'Login failed',
          'details': jsonDecode(response.body)
        };
      }
    } catch (e) {
      print('Error during login: $e');
      return {'error': e.toString()};
    }
  }

  Future<dynamic> register(Member member) async {
    try {
      final url = Uri.parse('$_baseUrl/api/auth/register');

      print(
          'Register attempt with username: ${member.username}, email: ${member.email}');

      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              {'username': member.username, 'password': member.username}));
    } catch (e) {
      print('Error during register: $e');
      return {'error': e.toString()};
    }
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
