class UserModel {
  final String loginId;
  final String userId;
  final String userName;
  final String email;
  final String accessToken;
  final String refreshToken;
  final bool isActive;
  final String firstName;
  final String lastName;
  final UserDetails userDetails;

  UserModel({
    required this.loginId,
    required this.userId,
    required this.userName,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.isActive,
    required this.firstName,
    required this.lastName,
    required this.userDetails,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      loginId: json['loginId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      isActive: json['isActive'] ?? false,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      userDetails: UserDetails.fromJson(json['userDetails'] ?? {}),
    );
  }
}

class UserDetails {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final bool isActive;
  final String address;
  final String pincode;
  final String district;
  final String state;
  final String country;

  UserDetails({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.isActive,
    required this.address,
    required this.pincode,
    required this.district,
    required this.state,
    required this.country,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      isActive: json['isActive'] ?? false,
      address: json['address'] ?? '',
      pincode: json['pincode'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
