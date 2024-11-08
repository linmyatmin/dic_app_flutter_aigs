import 'dart:convert';

import 'package:dic_app_flutter/models/subscription_plan_model.dart';
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

  // AuthNotifier(this.authAPI, this._googleSignIn, this._secureStorage)
  //     : super(AuthState());

  AuthNotifier(this.authAPI, this._googleSignIn, this._secureStorage)
      : super(AuthState()) {
    // Check for stored user when initializing
    checkStoredUser();
  }

  Future<void> checkStoredUser() async {
    try {
      final user = await _secureStorage.getUser();
      if (user != null) {
        state = state.copyWith(
          isAuthenticated: true,
          token: user.token,
          userId: user.userId,
          user: user,
        );

        // fetch the latest user data from the backend
        await fetchUserData();
      }
    } catch (e) {
      print('Error checking stored user: $e');
      await logout();
    }
  }

  Future<void> fetchUserData() async {
    try {
      // Fetch user data from backend
      final updatedUser = await authAPI.getUserData(state.userId, state.token);
      state = state.copyWith(user: updatedUser);
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authAPI.login(email, password);

      if (response['success'] == false) {
        throw response['message'] ?? 'Login failed';
      }

      final data = response['data'];
      if (data == null) {
        throw 'Invalid login response: missing data';
      }

      final token = data['token']?.toString();
      final userId = data['userId']?.toString();
      final userName = data['userName']?.toString() ?? '';
      final userEmail = data['email']?.toString() ?? email;
      final subscriptionPlanId = data['subscriptionPlanId']?.toString() ?? '';
      final startDate = data['startDate']?.toString() ?? '';
      final endDate = data['endDate']?.toString() ?? '';
      final status = data['status']?.toString() ?? '';
      final subscriptionPrice = data['subscriptionPrice']?.toString() ?? '';
      final isTrial = data['isTrial']?.toString() ?? '';
      final trialEndDate = data['trialEndDate']?.toString() ?? '';

      if (token == null || userId == null) {
        throw 'Invalid login response: missing token or userId';
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

      // Store user in secure storage
      await _secureStorage.saveUser(user);

      state = state.copyWith(
        isAuthenticated: true,
        token: user.token,
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
      String errorMessage = e.toString();
      if (e.toString().contains('DioError')) {
        try {
          final response = json.decode(e.toString());
          errorMessage = response['message'] ?? 'Login failed';
        } catch (_) {
          errorMessage = 'Network error occurred';
        }
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        isAuthenticated: false,
      );
      throw errorMessage;
    }
  }

  Future<void> logout() async {
    try {
      await _secureStorage.deleteUser();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all stored preferences
      state = AuthState(); // Reset to initial state
    } catch (e) {
      print('Error during logout: $e');
      throw 'Failed to sign out';
    }
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

      // Check if the response indicates an error
      if (response['success'] == false) {
        throw response['message'] ?? 'Registration failed';
      }

      final user = UserModel.fromJson(response['data']);
      await _secureStorage.saveUser(user);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      // state = state.copyWith(error: e.toString(), isLoading: false);
      String errorMessage = e.toString();
      // Handle DioError or other network errors
      if (e.toString().contains('DioError')) {
        try {
          final response = json.decode(e.toString());
          errorMessage = response['message'] ?? 'Registration failed';
        } catch (_) {
          errorMessage = 'Network error occurred';
        }
      }
      state = state.copyWith(
        error: errorMessage,
        isLoading: false,
      );
      throw errorMessage;
    }
  }

  Future<void> updateUserSubscription(
      Map<String, dynamic> subscriptionData) async {
    try {
      // Assuming you have a method to parse the subscription data into a Subscription object
      final updatedSubscription =
          SubscriptionPlan.fromJson(subscriptionData['subscriptionPlan']);

      print('updatedSubscription: $updatedSubscription');

      // Update the user state with the new subscription information
      state = state.copyWith(
        user: state.user?.copyWith(
            // subscriptionPlanId: updatedSubscription.subscriptionPlanId,
            subscriptionPlanId: updatedSubscription.id,
            // Update other fields as necessary
            subscriptionPrice: updatedSubscription.price),
      );
    } catch (e) {
      print('Error updating user subscription: $e');
    }
  }

  void updateUser(UserModel user) {
    state = state.copyWith(user: user);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authAPI = AuthAPI();
  final googleSignIn = ref.watch(googleSignInProvider);
  final secureStorage = SecureStorageService();
  return AuthNotifier(authAPI, googleSignIn, secureStorage);
});
