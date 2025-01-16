import 'package:dic_app_flutter/models/subscription_plan_model.dart';

class Subscription {
  int id;
  String plan;
  DateTime subscribedOn;
  DateTime expiredOn;

  Subscription({
    required this.id,
    required this.plan,
    required this.subscribedOn,
    required this.expiredOn,
  });
}

class SubscriptionStatus {
  final int planId;
  final String planName;
  final DateTime endDate;
  final String status;
  final bool isActive;

  SubscriptionStatus({
    required this.planId,
    required this.planName,
    required this.endDate,
    required this.status,
    required this.isActive,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      planId: json['planId'],
      planName: json['planName'],
      endDate: DateTime.parse(json['endDate']),
      status: json['status'],
      isActive: json['isActive'],
    );
  }
}

class SubscriptionChangeResponse {
  final bool success;
  final String? checkoutSessionId;
  final bool requiresAction;
  final String message;

  SubscriptionChangeResponse({
    required this.success,
    this.checkoutSessionId,
    required this.requiresAction,
    required this.message,
  });

  factory SubscriptionChangeResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionChangeResponse(
      success: json['success'],
      checkoutSessionId: json['checkoutSessionId'],
      requiresAction: json['requiresAction'],
      message: json['message'],
    );
  }
}

// class SubscriptionPlan {
//   final int id;
//   final String name;
//   final double price;
//   final String duration;
//   final String durationUnit;
//   final List<String> features;
//   final bool isActive;

//   SubscriptionPlan({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.duration,
//     required this.durationUnit,
//     required this.features,
//     required this.isActive,
//   });
// }

class ChangePlanRequest {
  final int planId;

  ChangePlanRequest({required this.planId});

  Map<String, dynamic> toJson() => {
        'planId': planId,
      };
}

class ChangePlanResponse {
  final bool success;
  final String message;
  final String? checkoutSessionId;
  final bool requiresAction;

  ChangePlanResponse({
    required this.success,
    required this.message,
    this.checkoutSessionId,
    required this.requiresAction,
  });

  factory ChangePlanResponse.fromJson(Map<String, dynamic> json) {
    return ChangePlanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      checkoutSessionId: json['checkoutSessionId'],
      requiresAction: json['requiresAction'] ?? false,
    );
  }
}

class SubscriptionState {
  final SubscriptionPlan? currentSubscription;
  final bool isLoading;
  final String? error;

  SubscriptionState({
    this.currentSubscription,
    this.isLoading = false,
    this.error,
  });

  SubscriptionState copyWith({
    SubscriptionPlan? currentSubscription,
    bool? isLoading,
    String? error,
  }) {
    return SubscriptionState(
      currentSubscription: currentSubscription ?? this.currentSubscription,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
