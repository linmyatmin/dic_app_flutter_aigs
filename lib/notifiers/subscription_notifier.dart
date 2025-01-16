import 'package:dic_app_flutter/models/subscription.dart';
import 'package:dic_app_flutter/models/subscription_plan_model.dart';
import 'package:dic_app_flutter/notifiers/auth_notifier.dart';
import 'package:dic_app_flutter/services/subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final SubscriptionService _subscriptionService;
  final String userId;

  SubscriptionNotifier(this._subscriptionService, this.userId)
      : super(SubscriptionState());

  Future<void> createSubscription(SubscriptionPlan plan) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final startDate = DateTime.now();
      final endDate = _subscriptionService.calculateEndDate(plan, startDate);

      await _subscriptionService.createUserSubscription(
        userId: userId,
        planId: plan.id,
        startDate: startDate,
        endDate: endDate,
        price: plan.price,
      );

      await getCurrentSubscription();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> getCurrentSubscription() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final subscription =
          await _subscriptionService.getCurrentSubscription(userId);
      state = state.copyWith(
        currentSubscription: subscription,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<ChangePlanResponse> changePlan(int planId, String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('SubscriptionNotifier changePlan planId: $planId');
      final response = await _subscriptionService.changePlan(planId, userId);

      if (response.success) {
        // If no payment required, refresh subscription
        if (!response.requiresAction) {
          await getCurrentSubscription();
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }

      return response;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  final userId = ref.read(authProvider).user?.userId ?? '';
  return SubscriptionNotifier(SubscriptionService(), userId);
});
