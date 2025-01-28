class ProfileModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String zipcode;
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
  final String city;
  final String profileImageId; // Corrected typo here
  final String divisionId;
  final String districtId;
  final String userName;
  final String roleName;
  final String createdBy;
  final String createdByUserName; // Corrected typo here
  final String createdDate;
  final String modifiedBy;
  final String modifiedByUserName; // Corrected typo here
  final String modifiedDate;
  final String deletedBy;
  final String deletedByUserName; // Corrected typo here
  final String deletedDate;
  final String savedBy;
  final String savedByUserName; // Corrected typo here
  final String savedDate;
  final String password; // Added password field

  ProfileModel({
    required this.city,
    required this.zipcode,
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
    required this.divisionId,
    required this.districtId,
    required this.userName,
    required this.roleName,
    required this.createdBy,
    required this.createdByUserName, // Corrected typo here
    required this.createdDate,
    required this.modifiedBy,
    required this.modifiedByUserName, // Corrected typo here
    required this.modifiedDate,
    required this.deletedBy,
    required this.deletedByUserName, // Corrected typo here
    required this.deletedDate,
    required this.savedBy,
    required this.savedByUserName, // Corrected typo here
    required this.savedDate,
    required this.gender,
    required this.password, // Added password field
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(

      userId: json['userId'] ?? '',
      zipcode: json['pincode'] ?? '',
      city: json['city'] ?? '',
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
      divisionId: json['divisionId'] ?? '',
      districtId: json['districtId'] ?? '',
      userName: json['userName'] ?? '',
      roleName: json['roleName'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdByUserName: json['createdByUserName'] ?? '', // Corrected typo here
      createdDate: json['createdDate'] ?? '',
      modifiedBy: json['modifiedBy'] ?? '',
      modifiedByUserName: json['modifiedByUserName'] ?? '', // Corrected typo here
      modifiedDate: json['modifiedDate'] ?? '',
      deletedBy: json['deletedBy'] ?? '',
      deletedByUserName: json['deletedByUserName'] ?? '', // Corrected typo here
      deletedDate: json['deletedDate'] ?? '',
      savedBy: json['savedBy'] ?? '',
      savedByUserName: json['savedByUserName'] ?? '', // Corrected typo here
      savedDate: json['savedDate'] ?? '',
      gender: json['gender'] ?? '',
      password: json['password'] ?? '', // Added password field
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
      'pofileImageId': profileImageId,
      'divisionId': divisionId,
      'districtId': districtId,
      'userName': userName,
      'roleName': roleName,
      'createdBy': createdBy,
      'createdByUserName': createdByUserName, // Corrected typo here
      'createdDate': createdDate,
      'modifiedBy': modifiedBy,
      'modifiedByUserName': modifiedByUserName, // Corrected typo here
      'modifiedDate': modifiedDate,
      'deletedBy': deletedBy,
      'deletedByUserName': deletedByUserName, // Corrected typo here
      'deletedDate': deletedDate,
      'savedBy': savedBy,
      'savedByUserName': savedByUserName, // Corrected typo here
      'savedDate': savedDate,
      'pincode':zipcode,
      'password': password,
      'city': city, // Added password field
    };
  }
}

class GenderOption {
  final String text;
  final String value;
  final bool selected;

  GenderOption({
    required this.text,
    required this.value,
    required this.selected,
  });

  factory GenderOption.fromJson(Map<String, dynamic> json) {
    return GenderOption(
      text: json['text'] ?? '', // Provide a default value for null
      value: json['value'] ?? '', // Provide a default value for null
      selected: json['selected'] ?? false, // Provide a default value for null
    );
  }
}
