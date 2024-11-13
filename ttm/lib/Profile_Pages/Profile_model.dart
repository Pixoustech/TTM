// profile_model.dart
class ProfileModel {
  String firstName;
  String lastName;
  String dateOfBirth;
  String gender;
  String role;
  String email;
  String phone;
  String city;
  String zipCode;

  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.role,
    required this.email,
    required this.phone,
    required this.city,
    required this.zipCode,
  });
}
final ProfileModel profile = ProfileModel(
  firstName: "surya",
  lastName: "Doe",
  dateOfBirth: "01/01/1990",
  gender: "Male",
  role: "User ",
  email: "john.doe@example.com",
  phone: "+1234567890",
  city: "New York",
  zipCode: "10001",
);