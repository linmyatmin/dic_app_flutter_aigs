import 'package:dic_app_flutter/models/user_model.dart';
import 'package:dic_app_flutter/network/auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AuthAPI _authAPI = AuthAPI();
  final Dio _dio = Dio();

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final currentUser = _auth.currentUser;
    return currentUser != null;
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign In was aborted by user');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('Google Auth AccessToken: ${googleAuth.accessToken}');
      print('Google Auth IdToken: ${googleAuth.idToken}');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Full Credential Details: $credential');

      try {
        final userCredential = await _auth.signInWithCredential(credential);
        print(
            'Successfully signed in with Google: ${userCredential.user?.email}');
        return userCredential;
      } catch (signInError) {
        print('Firebase sign-in error: $signInError');
        throw signInError;
      }
    } catch (e) {
      print('Detailed Google Sign In error: $e');
      await _auth.signOut();
      await _googleSignIn.signOut();
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();

      // Clear stored user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Send verification email
  Future<void> sendVerificationEmail(User user) async {
    await user.sendEmailVerification();
  }

  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmail(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Error registering with email: $e');
      return null;
    }
  }

  // Check if email is verified
  bool isEmailVerified(User user) {
    return user.emailVerified;
  }
}

class AuthResult {
  final bool success;
  final UserModel? user;
  final String? message;

  AuthResult({
    required this.success,
    this.user,
    this.message,
  });
}

// class User {
//   final String username;
//   final String email;

//   User({required this.username, required this.email});
// }
