import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String userId;
  final String email;
  final String userName;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? gender;
  final String token;
  final int subscriptionPlanId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? paymentId;
  final String? paymentMethod;
  final double subscriptionPrice;
  final bool isTrial;
  final DateTime trialEndDate;
  final bool active;

  UserModel({
    required this.userId,
    required this.email,
    required this.userName,
    this.firstName,
    this.lastName,
    this.image,
    this.gender,
    required this.token,
    required this.subscriptionPlanId,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.paymentId,
    this.paymentMethod,
    required this.subscriptionPrice,
    required this.isTrial,
    required this.trialEndDate,
    required this.active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
