import 'dart:convert';

import 'package:dic_app_flutter/models/subscription_plan_model.dart';
import 'package:dic_app_flutter/models/user_model.dart';
import 'package:dic_app_flutter/network/auth_api.dart';
import 'package:dic_app_flutter/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dic_app_flutter/services/auth_service.dart';

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

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.userGoogle,
    this.token,
    this.userId,
    this.userName,
    this.email,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    GoogleSignInAccount? userGoogle,
    String? token,
    String? userId,
    String? userName,
    String? email,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userGoogle: userGoogle ?? this.userGoogle,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthAPI authAPI;
  final GoogleSignIn _googleSignIn;
  final SecureStorageService _secureStorage;

  AuthNotifier(this.authAPI, this._googleSignIn, this._secureStorage)
      : super(AuthState(isAuthenticated: false));

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
      await signOut();
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
      //  state = AuthState(); // Reset to initial state
      state = AuthState(isAuthenticated: false); // Reset to initial state
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
      print('1. Starting Google Sign-In...');
      final userCredential = await AuthService().signInWithGoogle();
      print('2. Firebase Auth Result: ${userCredential?.user?.email}');

      if (userCredential == null) {
        // User cancelled the sign-in
        state = state.copyWith(isLoading: false);
        return;
      }

      if (userCredential?.user != null) {
        print('3. Getting Firebase token...');
        final firebaseToken = await userCredential?.user?.getIdToken();
        print('4. Token received, length: ${firebaseToken?.length}');

        print('5. Calling backend authentication...');
        final response = await authAPI.authenticateWithGoogle(
          email: userCredential?.user?.email ?? '',
          name: userCredential?.user?.displayName ?? '',
          firebaseToken: firebaseToken ?? '',
        );
        print('6. Backend Response: $response');

        if (response['success'] == false) {
          print('7. Backend auth failed: ${response['message']}');
          throw response['message'] ?? 'Google Sign-In failed';
        }

        final data = response['data'];
        print('8. Backend data: $data');
        if (data == null) {
          throw 'Invalid response: missing data';
        }

        final user = UserModel(
          token: data['token']?.toString() ?? '',
          userId: data['userId']?.toString() ?? '',
          userName: data['userName']?.toString() ?? '',
          email: data['email']?.toString() ?? userCredential?.user?.email ?? '',
          subscriptionPlanId:
              int.tryParse(data['subscriptionPlanId']?.toString() ?? '0') ?? 0,
          startDate: DateTime.tryParse(data['startDate']?.toString() ?? '') ??
              DateTime.now(),
          endDate: DateTime.tryParse(data['endDate']?.toString() ?? '') ??
              DateTime.now(),
          status: data['status']?.toString() ?? '',
          subscriptionPrice:
              double.tryParse(data['subscriptionPrice']?.toString() ?? '0.0') ??
                  0.0,
          isTrial: data['isTrial'] == true,
          trialEndDate:
              DateTime.tryParse(data['trialEndDate']?.toString() ?? '') ??
                  DateTime.now(),
          active: data['active'] == true,
        );

        // Save only sensitive data to secure storage
        await _secureStorage.saveUser(user);

        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
        );

        print('Updated state user: ${state.user}');
      }
    } catch (e) {
      print('Error in signInWithGoogle: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Authentication failed: $e',
        isAuthenticated: false,
      );
    }
  }

  Future<void> signOut() async {
    try {
      final authService = AuthService();
      await authService.signOut();

      // Clear secure storage
      await _secureStorage.deleteUser();

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      state = AuthState(isAuthenticated: false);
    } catch (e) {
      print('Error signing out: $e');
      state = state.copyWith(
        error: 'Sign out failed: $e',
        isAuthenticated: false,
      );
    }
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
