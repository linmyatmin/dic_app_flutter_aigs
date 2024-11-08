import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static const String _baseUrl = 'http://122.155.9.144/api/UserSubscriptions';

  // Initialize Stripe
  static Future<void> initialize() async {
    Stripe.publishableKey =
        'pk_test_51N6WAKJTMaf4YPFavjJJq7kElFcg07B4wOzsqpM1fqALPEB8DlFKMPQ0glPYmFYuqwGPXoNF5N0apwMIwtWfd6SQ0014CyiAD9';
    await Stripe.instance.applySettings();
  }

  // Create a payment intent
  static Future<Map<String, dynamic>> createPaymentIntent(
      String userId, int planId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'planId': planId,
        }),
      );

      print('stripe_service: userId: $userId, planId: $planId');

      // Check if the response status code indicates success
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Handle error response
        final errorResponse = jsonDecode(response.body);
        throw Exception('Error: ${errorResponse['message']}');
      }
    } catch (e) {
      throw 'Failed to create payment intent: $e';
    }
  }

  // Confirm the payment
  static Future<void> confirmPayment(String paymentIntentClientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Gempedia',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw 'Payment failed: $e';
    }
  }
}
