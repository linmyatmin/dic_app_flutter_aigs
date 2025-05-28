import 'package:dic_app_flutter/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dic_app_flutter/providers/recent_searches_provider.dart';
import 'services/stripe_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Providers
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final recentSearchesProvider =
    StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return RecentSearchesNotifier(prefs);
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    final prefs = await SharedPreferences.getInstance();

    // await StripeService.initialize();

    // Initialize Stripe with your publishable key
    // Stripe.publishableKey =
    //     'pk_test_51N6WAKJTMaf4YPFavjJJq7kElFcg07B4wOzsqpM1fqALPEB8DlFKMPQ0glPYmFYuqwGPXoNF5N0apwMIwtWfd6SQ0014CyiAD9'; // Replace with your actual publishable key
    // await Stripe.instance.applySettings();

    print("Stripe initialized successfully");

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const App(),
      ),
    );
  } catch (e) {
    print("Error during initialization: $e");
  }
}
