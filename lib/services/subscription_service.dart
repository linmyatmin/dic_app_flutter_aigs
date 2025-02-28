import 'package:dic_app_flutter/models/subscription.dart';
import 'package:dic_app_flutter/models/subscription_plan_model.dart';
import 'package:dic_app_flutter/services/stripe_service.dart';
import 'package:dic_app_flutter/services/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SubscriptionService {
  final Dio _dio = Dio();
  final String baseUrl = "http://122.155.9.144/api";
  final SecureStorageService _secureStorage = SecureStorageService();
  final StripeService _stripeService = StripeService();

  // Add authorization token to requests
  SubscriptionService() {
    _dio.options.followRedirects = true;
    _dio.options.validateStatus = (status) {
      return status! < 500; // Accept all status codes less than 500
    };

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final user = await _secureStorage.getUser();
        final token = user?.token;
        print('token: $token');

        if (token == null) {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'No authentication token found',
            ),
          );
        }

        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }

  // Get all subscription plans
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final response = await _dio.get('$baseUrl/subscriptionplans');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SubscriptionPlan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load subscription plans');
      }
    } catch (e) {
      throw Exception('Error getting subscription plans: $e');
    }
  }

  // Get current user subscription
  Future<SubscriptionPlan?> getCurrentSubscription(String userId) async {
    try {
      final response =
          await _dio.get('$baseUrl/UserSubscriptions/$userId/current');

      if (response.statusCode == 200) {
        // if (response.data['data'] != null) {
        if (response.data != null) {
          // return SubscriptionPlan.fromJson(response.data['data']);
          return SubscriptionPlan.fromJson(response.data['subscriptionPlan']);
        }
        return null;
      } else {
        throw Exception('Failed to load current subscription');
      }
    } catch (e) {
      throw Exception('Error getting current subscription: $e');
    }
  }

  Future<ChangePlanResponse> changePlan(int planId, String userId) async {
    try {
      // First get the subscription plan to get Stripe IDs
      final plans = await getSubscriptionPlans();
      final selectedPlan = plans.firstWhere(
        (plan) => plan.id == planId,
        orElse: () => throw Exception('Plan not found'),
      );

      // First get payment intent from your backend
      final response = await _dio.post(
        '$baseUrl/UserSubscriptions/create-payment-intent',
        data: {
          'planid': planId,
          'userid': userId,
        },
      );

      if (response.statusCode != 200) {
        debugPrint('Failed to create payment intent: ${response.statusCode}');
        throw Exception(
            'Failed to create payment intent: ${response.statusCode}');
      }

      final clientSecret = response.data['clientSecret'];
      if (clientSecret == null) {
        debugPrint('No client secret received from server');
        throw Exception('No client secret received from server');
      }

      // Initialize payment sheet with the client secret
      await _stripeService.initPaymentSheet(
        clientSecret,
        selectedPlan.name ?? 'Subscription',
        selectedPlan.stripePriceId ?? '',
      );

      // Show the payment sheet and get payment result
      final paymentResult =
          await _stripeService.presentPaymentSheet(clientSecret);

      if (paymentResult == null) {
        debugPrint('Payment cancelled or failed');
        throw Exception('Payment cancelled or failed');
      }

      // Only after successful payment, update the subscription
      // final subscriptionResponse = await _dio.post(
      //   '$baseUrl/UserSubscriptions/change-plan',
      //   data: {
      //     'planid': planId,
      //     'userid': userId,
      //     // 'paymentId': paymentResult['paymentId'],
      //   },
      // );
      final subscriptionResponse = await _dio.post(
        '$baseUrl/UserSubscriptions/confirm-subscription', // New endpoint
        data: {
          'planId': planId,
          'userId': userId,
          'paymentId': paymentResult['paymentId'],
        },
      );

      print('subscriptionResponse: ${subscriptionResponse.data}');

      if (subscriptionResponse.statusCode != 200) {
        throw Exception(
            'Failed to update subscription: ${subscriptionResponse.statusCode}');
      }

      return ChangePlanResponse.fromJson(subscriptionResponse.data);
    } catch (e) {
      debugPrint('Error changing plan: $e');
      throw Exception('Failed to change subscription plan: $e');
    }
  }

  // Add method to handle failed payments
  Future<void> revertFailedSubscription() async {
    try {
      await _dio.post('/api/subscription/revert-failed-payment');
    } catch (e) {
      debugPrint('Error reverting failed subscription: $e');
    }
  }

  // Create new subscription
  Future<void> createUserSubscription({
    required String userId,
    required int planId,
    required DateTime startDate,
    required DateTime endDate,
    String status = 'Active',
    double? price,
    String? transactionId,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/usersubscriptions',
        data: {
          'userid': userId,
          'SubscriptionPlanId': planId,
          // 'StartDate': startDate.toIso8601String(),
          // 'EndDate': endDate.toIso8601String(),
          // 'status': status,
          'SubscriptionPrice': price ?? 0.00,
          // 'PaymentId': userId, //transactionId,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
            'Failed to create subscription: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error creating subscription: $e');
    }
  }

  // Calculate subscription end date
  DateTime calculateEndDate(SubscriptionPlan plan, DateTime startDate) {
    // Convert numeric duration unit to string if needed
    String unit = plan.durationUnit is int
        ? _getDurationUnitString(plan.durationUnit)
        : plan.durationUnit.toString().toLowerCase();

    switch (unit) {
      case 'days':
        return startDate.add(Duration(days: plan.duration));
      case 'weeks':
        return startDate.add(Duration(days: plan.duration * 7));
      case 'months':
        return DateTime(
          startDate.year,
          startDate.month + plan.duration,
          startDate.day,
        );
      case 'years':
        return DateTime(
          startDate.year + plan.duration,
          startDate.month,
          startDate.day,
        );
      default:
        throw Exception('Invalid duration unit: ${plan.durationUnit}');
    }
  }

  String _getDurationUnitString(int unit) {
    switch (unit) {
      case 0:
        return 'days';
      case 1:
        return 'weeks';
      case 2:
        return 'months';
      case 3:
        return 'years';
      default:
        throw Exception('Unknown duration unit value: $unit');
    }
  }
}
