import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ttm/Profile_Pages/Service.dart';
import '../Comman_pages/Constant.dart';
import 'Profile_model.dart';
import 'package:http/http.dart' as http;

import 'Profile_page.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool isLoading = true; // Variable to track if data is still loading
  bool isEditing = false;
  XFile? _imageFile; // Variable to hold the selected image
  ProfileModel? profile; // Variable to hold the fetched profile data
  List<GenderOption> genderOptions = [];

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController isActiveController = TextEditingController();
  final TextEditingController roleIdController = TextEditingController();
  final TextEditingController divisionIdController = TextEditingController();
  final TextEditingController branchIdController = TextEditingController();
  final TextEditingController userGroupController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController districtIdController = TextEditingController();
  final TextEditingController genderIdController = TextEditingController();
  final TextEditingController countryIdController = TextEditingController();
  final TextEditingController stateIdController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Fetch user profile data on initialization
    _fetchGenderOptions();
  }
  Future<void> _fetchUserProfile() async {
    final userService = ApiService();
    try {
      final fetchedProfile = await userService.fetchUserProfile(AppConstants.userId ?? '');
      if (fetchedProfile != null) {
        setState(() {
          firstNameController.text = fetchedProfile.firstName ?? '';
          lastNameController.text = fetchedProfile.lastName ?? '';
          dobController.text = fetchedProfile.dob ?? '';
          emailController.text = fetchedProfile.email ?? '';
          mobileController.text = fetchedProfile.mobile ?? '';
          cityController.text = fetchedProfile.district ?? ''; // Assuming district = city
          usernameController.text = fetchedProfile.userName ?? ''; // Assuming userName is available
          passwordController.text = fetchedProfile.password;
          roleController.text=fetchedProfile.roleName;
          zipCodeController.text = fetchedProfile.zipcode;
          roleIdController.text = fetchedProfile.roleId;
          cityController.text = fetchedProfile.city;
genderController.text=fetchedProfile.gender;

          if (fetchedProfile.profileImageId.isNotEmpty) {
            _imageFile = XFile('http://ttm.dev.pixous.info/images/${fetchedProfile.profileImageId}');
          }
          setState(() {
            isLoading = false;
          });
        });
      } else {
        print('Profile is null');
      }
    } catch (e) {
      print('Error in _fetchUserProfile: $e');
    }
  }

  Future<void> _fetchGenderOptions() async {
    try {
      final response = await AppApi.dio.get('/Settings/User_Form_Get');

      if (response.statusCode == 200) {
        final data = response.data; // Use the response data directly
        if (data['status'] == 'SUCCESS') {
          setState(() {
            // Extract genderList from the nested data object
            genderOptions = (data['data']['genderList'] as List)
                .map((item) => GenderOption.fromJson(item))
                .toList();
          });
        }
      } else {
        throw Exception('Failed to load gender options');
      }
    } catch (e) {
      print('Error fetching gender options: $e');
    }
  }


  Future<void> _requestPermissions() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _pickImage() async {
    await _requestPermissions(); // Request permissions
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // If cropping is needed, uncomment the following lines
      // final croppedFile = await ImageCropper().cropImage(
      //   sourcePath: image.path,
      //   aspectRatioPresets: [
      //     CropAspectRatioPreset.square,
      //   ],
      //   uiSettings: [
      //     AndroidUiSettings(
      //       toolbarTitle: 'Crop Image',
      //       toolbarColor: AppColors.concolor,
      //       toolbarWidgetColor: Colors.white,
      //       initAspectRatio: CropAspectRatioPreset.original,
      //       lockAspectRatio: true,
      //     ),
      //   ],
      // );

      setState(() {
        _imageFile = image; // Use `croppedFile` if using cropper
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
                TextButton(
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
                SizedBox(width: 8), // Add some space between the buttons
                TextButton(
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.montserrat(
                      color: Colors.white, // White text color
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.concolor, // Background color of the button
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Increase padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    _updateProfile();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _updateProfile() async {
    try {
      // Check if `genderOptions` is populated and get the selected gender
      final selectedGender = genderOptions.isNotEmpty
          ? genderOptions.firstWhere(
            (option) => option.value == genderController.text,
        orElse: () => genderOptions[0],
      )
          : null;

      if (selectedGender == null) {
        // Show an error if no gender is selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: const Text('Please select a valid gender.'),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      // Gather data from text fields
      final updatedProfileData = {
        'userId': AppConstants.userId ?? '', // Use the user ID from your constants
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'mobile': mobileController.text.trim(),
        'isActive': true,
        'roleId': roleIdController.text.trim(),
        'divisionId': divisionIdController.text.trim(),
        'branchId': branchIdController.text.trim(),
        'userGroup': userGroupController.text.trim(),
        'dob': dobController.text.trim(),
        'districtId': districtIdController.text.trim(),
        'genderId': selectedGender.value,
        'countryId': countryIdController.text.trim(),
        'stateId': stateIdController.text.trim(),
        'city': cityController.text.trim(),
        'pincode': zipCodeController.text.trim(),
        'address': cityController.text.trim(),
        'password': passwordController.text.trim(),
        'userName': usernameController.text.trim(),
      };

      // Make the POST request using Dio
      final response = await AppApi.dio.post(
        '/Settings/User_SaveUpdate', // Relative path for the endpoint
        data: updatedProfileData,
      );

      if (response.statusCode == 200) {
        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: const Text('Profile updated successfully!'),
            duration: const Duration(seconds: 2),
          ),
        );

        // Upload the profile image if it exists
        if (_imageFile != null) {
          await _uploadProfileImage(_imageFile!);
        }

        await _fetchUserProfile(); // Refresh the profile data

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage()), // Navigate to ProfilePage
        );
      } else {
        // Handle API failure
        _showErrorSnackBar('Failed to update profile. Please try again.');
      }
    } catch (e) {
      print('Error updating profile: $e');
      _showErrorSnackBar('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> _uploadProfileImage(XFile imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://ttm.dev.pixous.info/api/Settings/User_UploadProfile'),
      );

      // Add the userId and any other required fields to the request
      request.fields['UserId'] = AppConstants.userId ?? ''; // Ensure this is the correct field name

      request.files.add(await http.MultipartFile.fromPath(
        'File', // Ensure this matches the expected field name in the API
        imageFile.path,
      ));

      // Send the request
      var response = await request.send();

      // Dismiss any previous SnackBar before showing a new one
      ScaffoldMessenger.of(context).clearSnackBars();

      if (response.statusCode == 200) {
        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: const Text('Profile image uploaded successfully!'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // Handle upload failure
        print('Failed to upload profile image: ${response.statusCode}');
        _showErrorSnackBar('Failed to upload profile image. Please try again.');
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      _showErrorSnackBar('Error uploading profile image. Please try again.');
    }
  }

  void _showErrorSnackBar(String message) {
    // Dismiss any previous SnackBar before showing a new one
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
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
      body: SingleChildScrollView(
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
                          radius: 70,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _imageFile != null
                              ? (_imageFile!.path.startsWith('http') // Check if the path is a URL
                              ? NetworkImage(_imageFile!.path) // Use NetworkImage for URLs
                              : FileImage(File(_imageFile!.path))) // Use FileImage for local files
                              : null,
                          child: _imageFile == null
                              ? Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          )
                              : null,
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
                _buildProfileField("Phone Number", mobileController),
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
            if (!isEditing && !isLoading)
              Positioned(
                right: 2,
                top: 2,
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
                      size: 30,
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
    if (label == "Date of Birth" && isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          alignment: Alignment.centerRight, // Align calendar icon to the right
          children: [
            TextField(
              controller: controller,
              enabled: false, // Make the TextField non-editable
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 12.0,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.concolor),
                ),
                hintText: 'Enter your $label',
              ),
              readOnly: true, // Ensure it cannot be directly edited
              onTap: () async {
                // Trigger the date picker when the field is tapped
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  // Format the selected date as needed
                  String formattedDate = "${pickedDate.toLocal()}".split(' ')[0];
                  setState(() {
                    controller.text = formattedDate; // Update the controller
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.calendar_today, color: AppColors.concolor),
              onPressed: () async {
                // Show the date picker on icon press
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  // Format the selected date
                  String formattedDate = "${pickedDate.toLocal()}".split(' ')[0];
                  setState(() {
                    controller.text = formattedDate;
                  });
                }
              },
            ),
          ],
        ),
      );
    }

    else if (label == "Gender" && isEditing) {
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
            DropdownButtonFormField<GenderOption>(
              value: genderOptions.isNotEmpty && genderController.text.isNotEmpty
                  ? genderOptions.firstWhere(
                    (option) => option.value == genderController.text,
                orElse: () => genderOptions[0],
              )
                  : null, // Set to null if genderOptions is empty
              items: genderOptions.map((GenderOption option) {
                return DropdownMenuItem<GenderOption>(
                  value: option,
                  child: Text(option.text),
                );
              }).toList(),
              onChanged: (GenderOption? newValue) {
                setState(() {
                  genderController.text = newValue?.value ?? '';
                });
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 12.0,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.concolor),
                ),
                hintText: 'Select your $label',
              ),
            ),
          ],
        ),
      );
    }
    else {
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
              height: 50,
              child: TextField(
                controller: controller,
                enabled: isEditing,
                style: TextStyle(
                  color: isEditing ? Colors.black : Colors.grey,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 12.0,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.concolor),
                  ),
                  hintText: 'Enter your $label',
                ),
                cursorColor: AppColors.concolor,
              ),
            ),
          ],
        ),
      );
    }
  }


}