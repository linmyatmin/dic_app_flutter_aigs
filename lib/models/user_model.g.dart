// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: json['userId'] as String,
      email: json['email'] as String,
      userName: json['userName'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      image: json['image'] as String?,
      gender: json['gender'] as String?,
      token: json['token'] as String,
      subscriptionPlanId: (json['subscriptionPlanId'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: json['status'] as String,
      paymentId: json['paymentId'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      subscriptionPrice: (json['subscriptionPrice'] as num).toDouble(),
      isTrial: json['isTrial'] as bool,
      trialEndDate: DateTime.parse(json['trialEndDate'] as String),
      active: json['active'] as bool,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'userName': instance.userName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
      'gender': instance.gender,
      'token': instance.token,
      'subscriptionPlanId': instance.subscriptionPlanId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'status': instance.status,
      'paymentId': instance.paymentId,
      'paymentMethod': instance.paymentMethod,
      'subscriptionPrice': instance.subscriptionPrice,
      'isTrial': instance.isTrial,
      'trialEndDate': instance.trialEndDate?.toIso8601String(),
      'active': instance.active,
    };
