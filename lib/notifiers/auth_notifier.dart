import 'package:dic_app_flutter/models/member.dart';
import 'package:dic_app_flutter/network/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(scopes: ['email']);
});

class AuthState {
  final Member? member;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final GoogleSignInAccount? user;
  AuthState(
      {this.member,
      this.isLoading = false,
      this.error,
      this.isAuthenticated = false,
      this.user});

  AuthState copyWith(
      {Member? member,
      bool? isLoading,
      String? error,
      bool? isAuthenticated,
      GoogleSignInAccount? user}) {
    return AuthState(
        member: member ?? this.member,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        user: user ?? this.user);
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthAPI authAPI;
  final GoogleSignIn _googleSignIn;

  AuthNotifier(this.authAPI, this._googleSignIn) : super(AuthState());
  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await authAPI.login(username, password);
      final member = Member.fromJson(response);
      state = state.copyWith(member: member, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void logout() {
    state = state.copyWith(member: null);
  }

  Future<void> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        state = state.copyWith(isAuthenticated: true, user: account);
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    // state = AuthState.initial();
    state = state.copyWith(user: null, isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthAPI(), ref.watch(googleSignInProvider));
});
