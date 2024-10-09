import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Constant.dart';

class CreateNewPasswordPage extends StatefulWidget {
  const CreateNewPasswordPage({super.key});

  @override
  _CreateNewPasswordPageState createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  void _createNewPassword() {
    setState(() {
      _isLoading = true;
      _successMessage = null;
      _errorMessage = null;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Mock successful response
      if (_newPasswordController.text.isNotEmpty &&
          _newPasswordController.text == _confirmPasswordController.text) {
        // Show custom success dialog
        showDialog(
          context: context,
          barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Circle with tick icon
                    DottedBorder(
                      color: AppColors.concolor, // Color of the dashed border
                      strokeWidth: 2, // Thickness of the dashed line
                      dashPattern: [8, 4], // Length of dashes and gaps
                      borderType: BorderType.Circle, // Circle shape
                      radius: Radius.circular(40), // Circle radius
                      child: Container(
                        width: 80, // Adjust to make the circle size as needed
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.concolor, // Inside circle background color
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor:Colors.white, // Same background color
                          child: Icon(
                            Icons.check,
                            size: 50,
                            color: AppColors.concolor, // Icon color
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20), // Space between the circle and the text

                    // Success message
                    Text(
                      "Successful",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height:10), // Space between the title and the description

                    Text(
                      "Congratulations!Your password has been changed.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2), // Space between the description and the button

                    Text(
                      "Click continue to login.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 14 ,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 30), // Space between the message and the button

                    // Continue button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        // Navigate to login screen or perform any desired action here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.concolor,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        setState(() {
          _errorMessage = "Passwords do not match or are empty.";
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: AppBar(
          flexibleSpace: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFBE898A),
                  Colors.white,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'Set a New Password',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.concolor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Create a new password. Ensure it differs from previous ones',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
                child: Column(
                  children: [
                    // Circular Icon or Image Above the Text Fields
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,

                            child: Image.asset(
                              'Assets/Images/Locktick.png', // Update with your image path
                              width: 40, // Adjust width as needed
                              height: 40, // Adjust height as needed
                              fit: BoxFit.fitHeight, // Make the image cover the entire circle
                            ),

                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Space between the icon and the text fields

                    // New Password Field
                    TextField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20), // Space between the new password field and the confirm password field

                    // Confirm Password Field
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20), // Space between the confirm password field and messages

                    if (_successMessage != null) ...[
                      Text(
                        _successMessage!,
                        style: TextStyle(color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                    ],
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                    ],
                    SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createNewPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF910002),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          minimumSize: Size(screenWidth, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'Submit',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
