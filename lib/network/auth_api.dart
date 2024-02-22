import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class AuthAPI {
  final String _baseUrl = "https://dummyjson.com";

  // Future<HttpResponse> registerUser() async{

  // }

  final Dio _dio = Dio();

  Future<dynamic> login(String username, String password) async {
    try {
      print('$username, $password');

      username = 'kminchelle';
      password = '0lelplR';
      // _dio.options.headers['content-Type'] = 'application/json';
      // _dio.options.headers["authorization"] = "token ${token}";
      Response response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          contentType: "application/json",
          // headers: {
          //   "authorization": "Bearer <your token>",
          // },
        ),
      );
      print('login_auth_api: $response');
      // queryParameters: {'apikey': ApiSecret.apiKey},
      // );
      return response;
    } on DioError catch (e) {
      return e.response!.data;
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
