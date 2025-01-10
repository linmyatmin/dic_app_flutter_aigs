//new 23-07-2024
import 'package:dic_app_flutter/network/auth_api.dart';
import 'package:dic_app_flutter/screens/home_screen.dart';
import 'package:dic_app_flutter/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:dic_app_flutter/screens/register_screen.dart';
import 'package:dic_app_flutter/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dic_app_flutter/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController =
      TextEditingController(text: 'lin@aigsthailand.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'AdminPassword123!');
  // final TextEditingController usernameController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();

  bool _showPassword = false;
  final AuthService _authService = AuthService();

  Future<void> _handleLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authProvider.notifier).login(
            usernameController.text.trim(),
            passwordController.text,
          );

      // // Fetch user data after successful login
      // final currentUser = ref.read(authProvider).user;
      // if (currentUser != null) {
      //   final userData = await AuthAPI().getUserData(currentUser.userId);
      //   ref.read(authProvider.notifier).updateUser(userData);
      // }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20,
          ),
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_showPassword : obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final primaryColor = Theme.of(context).primaryColor;
    final textColor =
        Theme.of(context).primaryTextTheme.titleLarge?.color ?? Colors.white;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textColor,
          ),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            ),
            child: Text(
              'Skip',
              style: TextStyle(color: textColor),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/icon/icon_no_bg.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    icon: Icons.person,
                    validator: Validator.validateName,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: Validator.validatePassword,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: authState.isLoading
                        ? null
                        : () => _handleLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  // const SizedBox(height: 16),
                  // TextButton.icon(
                  //   onPressed: () async {
                  //     await ref.read(authProvider.notifier).signInWithGoogle();
                  //   },
                  //   icon: Image.asset('assets/google_logo.png', height: 24),
                  //   label: const Text('Sign In with Google'),
                  //   style: TextButton.styleFrom(
                  //     primary: Colors.white,
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    ),
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  if (authState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Error: ${authState.error}',
                        style: TextStyle(color: Colors.red[300]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Or continue with',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        // final authService = ref.read(authServiceProvider);
                        // final userCredential =
                        //     await authService.signInWithGoogle();

                        // if (userCredential != null && context.mounted) {
                        //   Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const HomeScreen()),
                        //   );
                        // }
                        await ref
                            .read(authProvider.notifier)
                            .signInWithGoogle();

                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Failed to sign in with Google: $e')),
                          );
                        }
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/google_logo.png',
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text('Sign in with Google'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
