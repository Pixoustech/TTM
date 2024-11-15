// Assuming you have a UserModel like this:
class UserModel {
  final String token;
  final String name;
  final String userId;
  final String role;

  UserModel({
    required this.token,
    required this.name,
    required this.userId,
    required this.role,
  });

  // Update to handle null values
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['Token'] ?? '', // Provide a default value if null
      name: json['Name'] ?? 'Unknown',
      userId: json['UserId'] ?? '',
      role: json['Role'] ?? '',
    );
  }
}
