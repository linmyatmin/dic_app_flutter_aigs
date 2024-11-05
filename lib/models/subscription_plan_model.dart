import 'dart:convert';

class SubscriptionPlan {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int duration;
  final int durationUnit;
  final String? features;
  final bool active;
  final DateTime createDate;
  final String? createBy;
  final DateTime updateDate;
  final String? updateBy;

  SubscriptionPlan({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.duration,
    required this.durationUnit,
    this.features,
    required this.active,
    required this.createDate,
    this.createBy,
    required this.updateDate,
    this.updateBy,
  });

  factory SubscriptionPlan.fromRawJson(String str) =>
      SubscriptionPlan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as int,
      durationUnit: json['durationUnit'] as int,
      features: json['features'] as String?,
      active: json['active'] as bool,
      createDate: DateTime.parse(json['createDate'] as String),
      createBy: json['createBy'] as String?,
      updateDate: DateTime.parse(json['updateDate'] as String),
      updateBy: json['updateBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'duration': duration,
        'durationUnit': durationUnit,
        'features': features,
        'active': active,
        'createDate': createDate.toIso8601String(),
        'createBy': createBy,
        'updateDate': updateDate.toIso8601String(),
        'updateBy': updateBy,
      };
}
