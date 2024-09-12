//new 23-07-2024
import 'package:dic_app_flutter/screens/home_screen.dart';
import 'package:dic_app_flutter/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';

class LoginScreen extends ConsumerWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController =
      TextEditingController(text: 'emilys');
  final TextEditingController passwordController =
      TextEditingController(text: 'emilyspass');

  void _login(BuildContext context, WidgetRef ref, String _userName,
      String _password) async {
    final authNotifier = ref.read(authProvider.notifier);

    await authNotifier.login(
      _userName,
      _password,
    );

    final authState = ref.read(authProvider);

    if (authState.member != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${authState.error}')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;

    final authState = ref.watch(authProvider);

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (authState.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (authState.error != null) Text('Error: ${authState.error}'),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: usernameController,
                      validator: (value) {
                        return Validator.validateName(value ?? '');
                      },
                      decoration: InputDecoration(
                          hintText: 'Username',
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    )
                    // TextField(
                    //   controller: usernameController,
                    //   decoration: const InputDecoration(labelText: 'Username'),
                    // ),
                    ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      return Validator.validatePassword(value ?? '');
                    },
                    decoration: InputDecoration(
                        hintText: 'Password',
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    obscureText: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => _login(context, ref,
                          usernameController.text, passwordController.text),
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15)),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                if (authState.member != null)
                  Text('Welcome, ${authState.member?.firstName}'),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).signInWithGoogle();
                    },
                    child: const Text('Sign In with Google'),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
