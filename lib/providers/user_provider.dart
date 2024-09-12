import 'dart:convert';

import 'package:dic_app_flutter/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  UserElement? _user;

  UserElement? get user => _user;

  Future<void> _saveUserToPrefs(UserElement user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<void> _removeUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }

  Future<void> login(UserElement user) async {
    _user = user;
    notifyListeners();
    await _saveUserToPrefs(user);
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
    await _removeUserFromPrefs();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData!.isNotEmpty) {
      _user = UserElement.fromJson(jsonDecode(userData));
      notifyListeners();
    }
  }
}
