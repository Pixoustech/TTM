import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure you have this import for Google Fonts
import '../Comman_pages/Constant.dart';
import 'Profile_page.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _oldPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  Color _getLabelColor(FocusNode focusNode, TextEditingController controller) {
    if (focusNode.hasFocus || controller.text.isNotEmpty) {
      return AppColors.concolor; // Change this to your desired focused color
    }
    return Colors.grey; // Default color
  }

  void _createNewPassword() {
    // Implement your password update logic here
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Simulating a network call
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Hide loading indicator
        _errorMessage = null; // Clear any error message
      });

      // Show dialog box after updating password
      _showDialog("Success", "Your password has been updated successfully!");
    });
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set the background color to white
          title: Text(title),
          content: Text(message),
          actions: [
            Center( // Center the button
              child: SizedBox(
                width: double.infinity, // Make the button full width
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.concolor, // Set the background color to red
                    borderRadius: BorderRadius.circular(8), // Set the border radius for a box shape
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // Set the text color to white
                      padding: EdgeInsets.symmetric(vertical: 16), // Optional: add padding
                    ),
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to Profile Page
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: AppColors.concolor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Column(
                children: [
                  // Instruction Text
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Text(
                      "Create a new password.\nEnsure it differs from previous ones.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.lock, size: 40, color: AppColors.concolor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Old Password Field
                  _buildTextField(
                    controller: _oldPasswordController,
                    focusNode: _oldPasswordFocusNode,
                    label: 'Old Password',
                    hint: 'Enter your old password',
                  ),
                  const SizedBox(height: 20),

                  // New Password Field
                  _buildTextField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocusNode,
                    label: 'New Password',
                    hint: 'Enter your new password',
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  _buildTextField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    label: 'Confirm Password',
                    hint: 'Re-enter your new password',
                  ),

                  const SizedBox(height: 20),

                  // Full-width Loading Indicator and Update Button
                  ElevatedButton(
                    onPressed: _createNewPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.concolor,
                      padding: const EdgeInsets.symmetric(vertical: 16), // Remove horizontal padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 50), // Full width button
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoading)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Change loading color to red
                            ),
                          ),
                        Text(
                          _isLoading ? "" : "Update",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Success or Error Message
                  if (_successMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _successMessage!,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          focusNode: focusNode,
          cursorColor: AppColors.concolor, // Change cursor color here
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.concolor,
                width: 2.0,
              ),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey), // Style for hint text
          ),
          obscureText: true,
        ),
      ],
    );
  }
}
