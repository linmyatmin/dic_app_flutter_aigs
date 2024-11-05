import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:dic_app_flutter/models/user_model.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveUser(UserModel user) async {
    await _storage.write(key: 'user', value: json.encode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final userStr = await _storage.read(key: 'user');
    if (userStr != null) {
      return UserModel.fromJson(json.decode(userStr));
    }
    return null;
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: 'user');
  }
}
