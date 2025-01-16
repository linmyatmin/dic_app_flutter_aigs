import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';
import '../network/dio_client.dart';
import '../models/subscription_plan_model.dart';

// Provider for the subscription service
final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService();
});

// Provider for subscription plans
final subscriptionPlansProvider =
    FutureProvider<List<SubscriptionPlan>>((ref) async {
  final subscriptionService = ref.read(subscriptionServiceProvider);
  return subscriptionService.getSubscriptionPlans();
});

// Provider for current user subscription (if needed)
final userSubscriptionProvider =
    FutureProvider.autoDispose<SubscriptionPlan?>((ref) async {
  final service = ref.read(subscriptionServiceProvider);
  final authState = ref.watch(authProvider);

  if (!authState.isAuthenticated) return null;

  return service.getCurrentSubscription(authState.user!.userId);
});

// Provider for subscription status
final subscriptionStatusProvider = StateProvider<String>((ref) => 'inactive');
