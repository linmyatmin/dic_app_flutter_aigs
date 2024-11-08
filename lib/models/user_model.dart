import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String userId;
  final String email;
  final String userName;
  final String? firstName; // Nullable
  final String? lastName; // Nullable
  final String? image; // Nullable
  final String? gender; // Nullable
  final String? token; // Nullable
  final int subscriptionPlanId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? paymentId;
  final String? paymentMethod;
  final double subscriptionPrice;
  final bool isTrial;
  final DateTime? trialEndDate; // Nullable
  final bool active;

  UserModel({
    required this.userId,
    required this.email,
    required this.userName,
    this.firstName,
    this.lastName,
    this.image,
    this.gender,
    this.token,
    required this.subscriptionPlanId,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.paymentId,
    this.paymentMethod,
    required this.subscriptionPrice,
    required this.isTrial,
    this.trialEndDate,
    required this.active,
  });

  // New copyWith method
  UserModel copyWith({
    String? userId,
    String? email,
    String? userName,
    String? firstName,
    String? lastName,
    String? image,
    String? gender,
    String? token,
    int? subscriptionPlanId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? paymentId,
    String? paymentMethod,
    double? subscriptionPrice,
    bool? isTrial,
    DateTime? trialEndDate,
    bool? active,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      token: token ?? this.token,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      paymentId: paymentId ?? this.paymentId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subscriptionPrice: subscriptionPrice ?? this.subscriptionPrice,
      isTrial: isTrial ?? this.isTrial,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      active: active ?? this.active,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      email: json['email'],
      userName: json['userName'],
      firstName: json['firstName'], // Nullable
      lastName: json['lastName'], // Nullable
      image: json['image'], // Nullable
      gender: json['gender'], // Nullable
      token: json['token'], // Nullable
      subscriptionPlanId: json['subscriptionPlanId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'].toString(), // Ensure status is a String
      paymentId: json['paymentId'], // Nullable
      paymentMethod: json['paymentMethod'], // Nullable
      subscriptionPrice: (json['subscriptionPrice'] as num).toDouble(),
      isTrial: json['isTrial'],
      trialEndDate: json['trialEndDate'] != null
          ? DateTime.parse(json['trialEndDate']) // Handle null
          : null,
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
