class AuthResponse {
  final String userId;
  final String userName;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;
  final String token;
  final int? subscriptionPlanId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final String? paymentId;
  final String? paymentMethod;
  final double? subscriptionPrice;
  final bool? isTrial;
  final DateTime? trialEndDate;
  final bool? active;

  AuthResponse({
    required this.userId,
    required this.userName,
    required this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
    required this.token,
    this.subscriptionPlanId,
    this.startDate,
    this.endDate,
    this.status,
    this.paymentId,
    this.paymentMethod,
    this.subscriptionPrice,
    this.isTrial,
    this.trialEndDate,
    this.active,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      image: json['image'],
      token: json['token'] ?? '',
      subscriptionPlanId: json['subscriptionPlanId'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      status: json['status'],
      paymentId: json['paymentId'],
      paymentMethod: json['paymentMethod'],
      subscriptionPrice: json['subscriptionPrice']?.toDouble(),
      isTrial: json['isTrial'],
      trialEndDate: json['trialEndDate'] != null
          ? DateTime.parse(json['trialEndDate'])
          : null,
      active: json['active'],
    );
  }
}
