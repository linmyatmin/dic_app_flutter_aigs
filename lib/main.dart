import 'package:dic_app_flutter/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // // Ensure all Flutter bindings are initialized
  // WidgetsFlutterBinding.ensureInitialized();

  // // Initialize the UserProvider and load the user
  // final userProvider = UserProvider();
  // await userProvider.loadUser();

  // runApp(
  //   ChangeNotifierProvider(
  //     create: (_) => userProvider,
  //     child: App(),
  //   ),
  // );
  runApp(const ProviderScope(child: App()));
}
