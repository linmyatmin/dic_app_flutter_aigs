import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://122.155.9.144', // e.g., 'https://api.yourapp.com'
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // Add any other default configurations
    ),
  );

  // Add interceptors if needed
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        // final token = ref.read(authProvider).token;
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Handle errors globally
        print('DIO Error: ${error.message}');
        return handler.next(error);
      },
    ),
  );

  return dio;
});
