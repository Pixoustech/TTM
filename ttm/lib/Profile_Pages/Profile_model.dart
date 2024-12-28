class ProfileModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String dob;
  final String district;
  final String userNumber;
  final String prefix;
  final String suffix;
  final bool isActive;
  final String roleId;
  final String userGroup;
  final String branchId;
  final String gender;
  final String profileImageId; // Corrected typo here
  final String loginId;
  final String divisionId;
  final String districtId;
  final String userName;
  final String roleName;
  final String lastUpdatedBy;
  final String lastUpdatedUserName;
  final String lastUpdatedDate;

  ProfileModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.dob,
    required this.district,
    required this.userNumber,
    required this.prefix,
    required this.suffix,
    required this.isActive,
    required this.roleId,
    required this.userGroup,
    required this.branchId,
    required this.profileImageId,
    required this.loginId,
    required this.divisionId,
    required this.districtId,
    required this.userName,
    required this.roleName,
    required this.lastUpdatedBy,
    required this.lastUpdatedUserName,
    required this.lastUpdatedDate, required this.gender,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      dob: json['dob'] ?? '',
      district: json['district'] ?? '',
      userNumber: json['userNumber'] ?? '',
      prefix: json['prefix'] ?? '',
      suffix: json['suffix'] ?? '',
      isActive: json['isActive'] ?? false,
      roleId: json['roleId'] ?? '',
      userGroup: json['userGroup'] ?? '',
      branchId: json['branchId'] ?? '',
      profileImageId: json['pofileImageId'] ?? '', // Corrected typo here
      loginId: json['loginId'] ?? '',
      gender: json['gender'] ?? '',
      divisionId: json['divisionId'] ?? '',
      districtId: json['districtId'] ?? '',
      userName: json['userName'] ?? '',
      roleName: json['roleName'] ?? '',
      lastUpdatedBy: json['lastUpdatedBy'] ?? '',
      lastUpdatedUserName: json['lastUpdatedUserName'] ?? '',
      lastUpdatedDate: json['lastUpdatedDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobile': mobile,
      'dob': dob,
      'district': district,
      'userNumber': userNumber,
      'gender': gender,
      'prefix': prefix,
      'suffix': suffix,
      'isActive': isActive,
      'roleId': roleId,
      'userGroup': userGroup,
      'branchId': branchId,
      'pofileImageId': profileImageId, // Corrected typo here
      'loginId': loginId,
      'divisionId': divisionId,
      'districtId': districtId,
      'userName': userName,
      'roleName': roleName,
      'lastUpdatedBy': lastUpdatedBy,
      'lastUpdatedUser Name': lastUpdatedUserName,
      'lastUpdatedDate': lastUpdatedDate,
    };
  }
}