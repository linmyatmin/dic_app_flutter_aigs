import 'package:dio/dio.dart';
import '../models/subscription_plan_model.dart';

class SubscriptionService {
  final Dio _dio;

  SubscriptionService(this._dio);

  // Get all subscription plans
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final response = await _dio.get('/api/subscriptionplans');

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
      final response = await _dio.get('/api/UserSubscriptions/$userId/current');

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
        '/api/usersubscriptions',
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
