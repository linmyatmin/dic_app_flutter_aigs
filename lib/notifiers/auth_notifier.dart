import 'package:dic_app_flutter/models/user_model.dart';
import 'package:dic_app_flutter/network/auth_api.dart';
import 'package:dic_app_flutter/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(scopes: ['email']);
});

class AuthState {
  final UserModel? user;

  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final GoogleSignInAccount? userGoogle;
  final String? token;
  final String? userId;
  final String? userName;
  final String? email;

  AuthState(
      {this.user,
      this.isLoading = false,
      this.error,
      this.isAuthenticated = false,
      this.userGoogle,
      this.token,
      this.userId,
      this.userName,
      this.email});

  AuthState copyWith(
      {UserModel? user,
      bool? isLoading,
      String? error,
      bool? isAuthenticated,
      GoogleSignInAccount? userGoogle,
      String? token,
      String? userId,
      String? userName,
      String? email}) {
    return AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        userGoogle: userGoogle ?? this.userGoogle,
        token: token ?? this.token,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        email: email ?? this.email);
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthAPI authAPI;
  final GoogleSignIn _googleSignIn;
  final SecureStorageService _secureStorage;

  AuthNotifier(this.authAPI, this._googleSignIn, this._secureStorage)
      : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authAPI.login(email, password);

      print('Login response: $response');

      final token = response['token']?.toString();
      final userId = response['userId']?.toString();
      final userName = response['userName']?.toString() ?? '';
      final userEmail = response['email']?.toString() ?? email;
      final subscriptionPlanId =
          response['subscriptionPlanId']?.toString() ?? '';
      final startDate = response['startDate']?.toString() ?? '';
      final endDate = response['endDate']?.toString() ?? '';
      final status = response['status']?.toString() ?? '';
      final subscriptionPrice = response['subscriptionPrice']?.toString() ?? '';
      final isTrial = response['isTrial']?.toString() ?? '';
      final trialEndDate = response['trialEndDate']?.toString() ?? '';

      if (token == null || userId == null) {
        throw 'Invalid login response';
      }

      final user = UserModel(
        subscriptionPlanId: int.tryParse(subscriptionPlanId) ?? 0,
        startDate:
            startDate.isNotEmpty ? DateTime.parse(startDate) : DateTime.now(),
        endDate: endDate.isNotEmpty
            ? DateTime.parse(endDate)
            : DateTime.now().add(const Duration(days: 30)),
        status: status,
        subscriptionPrice: double.tryParse(subscriptionPrice) ?? 0.0,
        isTrial: isTrial == 'true',
        trialEndDate: trialEndDate.isNotEmpty
            ? DateTime.parse(trialEndDate)
            : DateTime.now().add(const Duration(days: 14)),
        active: true,
        token: token,
        userId: userId,
        userName: userName,
        email: userEmail,
      );

      print('Created user model: $user');

      state = state.copyWith(
        isAuthenticated: true,
        token: token,
        userId: userId,
        user: user,
        isLoading: false,
      );

      print('Updated state user: ${state.user}');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setString('userName', userName);
      await prefs.setString('email', userEmail);
      await prefs.setString('subscriptionPlanId', subscriptionPlanId);
      await prefs.setString('startDate', startDate);
      await prefs.setString('endDate', endDate);
      await prefs.setString('status', status);
      await prefs.setString('subscriptionPrice', subscriptionPrice);
      await prefs.setString('isTrial', isTrial);
      await prefs.setString('trialEndDate', trialEndDate);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    await _secureStorage.deleteUser();
    state = AuthState();
  }

  Future<void> loadUser() async {
    state = state.copyWith(isLoading: true);
    final user = await _secureStorage.getUser();
    state = state.copyWith(user: user, isLoading: false);
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authAPI.signInWithGoogle();
      final user = UserModel.fromJson(response);
      await _secureStorage.saveUser(user);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    state = state.copyWith(userGoogle: null, isAuthenticated: false);
  }

  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authAPI.register(username, email, password);
      final user = UserModel.fromJson(response);
      await _secureStorage.saveUser(user);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authAPI = AuthAPI();
  final googleSignIn = ref.watch(googleSignInProvider);
  final secureStorage = SecureStorageService();
  return AuthNotifier(authAPI, googleSignIn, secureStorage);
});
