import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Comman_pages/Constant.dart';
import 'Profile_model.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool isEditing = false;
  XFile? _imageFile; // Variable to hold the selected image

  // Controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  // Sample data for a profile
  final ProfileModel profile = ProfileModel(
    firstName: "John",
    lastName: "Doe",
    dateOfBirth: "01/01/1990",
    gender: "Male",
    role: "User  ",
    email: "john.doe@example.com",
    phone: "+1234567890",
    city: "New York",
    zipCode: "10001",
  );

  _MyProfilePageState() {
    firstNameController.text = profile.firstName;
    lastNameController.text = profile.lastName;
    dobController.text = profile.dateOfBirth;
    genderController.text = profile.gender;
    roleController.text = profile.role;
    emailController.text = profile.email;
    phoneController.text = profile.phone;
    cityController.text = profile.city;
    zipCodeController.text = profile.zipCode;
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
  }

  Future<void> _pickImage() async {
    await _requestPermissions(); // Request permissions
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = image; // Set the selected image
      });
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set the background color to white
          title: Text(
            'Confirm Update',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 20, // You can adjust the font size as needed
            ),
          ),
          content: Text(
            'Are you sure you want to update your profile?',
            style: GoogleFonts.montserrat(fontSize: 16), // Use Montserrat font
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the right
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1), // Increase padding
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the button
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    border: Border.all(color: AppColors.concolor), // Border color
                  ),
                  child: TextButton(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.montserrat(
                        color: AppColors.concolor, // Set text color
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
                SizedBox(width: 8), // Add some space between the buttons
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1), // Increase padding
                  decoration: BoxDecoration(
                    color: AppColors.concolor, // Background color of the button
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: TextButton(
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.montserrat(
                        color: Colors.white, // White text color
                      ),
                    ),
                    onPressed: () {
                      // Handle the update logic here
                      _updateProfile();
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _updateProfile() {
    // Here you can add your update logic
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:Colors.green,
        content: const Text('Profile updated successfully!'),
        duration: const Duration(seconds: 1), // Duration for the snackbar
      ),
    );

    // Optionally, you can navigate back after a delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // Pop the profile page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.concolor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 155,
                        height: 155,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF7E1416),
                              Color(0xFFDA7B83),
                            ],
                            stops: [0.0, 1.0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(9),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _imageFile != null ? FileImage(File(_imageFile!.path)) : null,
                          child: _imageFile == null ? Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ) : null,
                        ),
                      ),
                      if (isEditing)
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              _pickImage(); // Open gallery to pick image
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: AppColors.concolor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Space between profile picture and labels
                // Profile Labels with TextFields
                _buildProfileField("First Name", firstNameController),
                _buildProfileField("Last Name", lastNameController),
                _buildProfileField("Date of Birth", dobController),
                _buildProfileField("Gender", genderController),
                _buildProfileField("Role", roleController),
                _buildProfileField("Email Address", emailController),
                _buildProfileField("Phone Number", phoneController),
                _buildProfileField("City", cityController),
                _buildProfileField("Zip Code", zipCodeController),
                if (isEditing)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: SizedBox(
                      width: double.infinity, // Full width button
                      child: ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(); // Show confirmation dialog
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.white), // White text
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.concolor, // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Pencil Icon
            if (!isEditing) // Show pencil icon only when not editing
              Positioned(
                right: 2, // Distance from the right edge
                top: 2, // Distance from the top edge
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isEditing = !isEditing; // Toggle edit mode
                    });
                    print("Edit profile clicked");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.concolor,
                      size: 30, // Size of the pencil icon
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 50, // Set a fixed height for the TextField
            child: TextField(
              controller: controller,
              enabled: isEditing, // Enable or disable based on edit mode
              style: TextStyle(
                color: isEditing ? Colors.black : Colors.grey, // Change text color
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 12.0, // Adjust vertical padding
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Default border color
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.concolor), // Focused border color
                ),
                hintText: 'Enter your $label',
              ),
              cursorColor: AppColors.concolor, // Cursor color
            ),
          ),
        ],
      ),
    );
  }
}