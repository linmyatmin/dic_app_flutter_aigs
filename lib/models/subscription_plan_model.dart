import 'dart:convert';
import 'dart:ffi';

class SubscriptionPlan {
  final int id;
  final String? name;
  final String? description;
  final double price;
  final int duration;
  final dynamic durationUnit;
  final bool active;
  final String? stripePriceId;
  final String? stripeProductId;

  SubscriptionPlan({
    required this.id,
    this.name,
    this.description,
    required this.price,
    required this.duration,
    required this.durationUnit,
    required this.active,
    this.stripePriceId,
    this.stripeProductId,
  });

  factory SubscriptionPlan.fromRawJson(String str) =>
      SubscriptionPlan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble() ?? 0.0,
      duration: json['duration'],
      durationUnit: json['durationUnit'],
      active: json['active'] ?? false,
      stripePriceId: json['stripePriceId'],
      stripeProductId: json['stripeProductId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'duration': duration,
        'durationUnit': durationUnit,
        'active': active,
        'stripePriceId': stripePriceId,
        'stripeProductId': stripeProductId,
      };
}
