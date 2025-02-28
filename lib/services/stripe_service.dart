import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  Future<void> initPaymentSheet(
    String paymentIntentClientSecret,
    String merchantDisplayName,
    String stripePriceId,
  ) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: merchantDisplayName,
          paymentIntentClientSecret: paymentIntentClientSecret,
          // Configure the payment sheet with the price ID
          customFlow: false,
          style: ThemeMode.system,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF0A5F02),
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error initializing payment sheet: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> presentPaymentSheet(String clientSecret) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // Get the payment intent details
      final paymentIntent = await Stripe.instance.retrievePaymentIntent(
        clientSecret, // Make sure this is stored as a class property when initialized
      );

      // Extract useful payment information
      return {
        'success': true,
        'paymentId': paymentIntent.id,
        'amount': paymentIntent.amount,
        'currency': paymentIntent.currency,
        'status': paymentIntent.status,
        'created': paymentIntent.created,
        // 'customerId': paymentIntent.customer,
        'paymentMethodId': paymentIntent.paymentMethodId,
        // 'metadata': paymentIntent.metadata,
      };
    } on StripeException catch (e) {
      debugPrint('Stripe error: ${e.error.message}');
      return {
        'success': false,
        'error': e.error.message,
      };
    } catch (e) {
      debugPrint('Error presenting payment sheet: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
