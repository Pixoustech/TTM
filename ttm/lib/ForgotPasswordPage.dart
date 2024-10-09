import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for input formatters
import 'package:google_fonts/google_fonts.dart';
import 'package:ttm/Constant.dart';
import 'Verify_OTP_page.dart'; // Import the new page

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  void _resetPassword() {
    setState(() {
      _isLoading = true;
      _successMessage = null;
      _errorMessage = null;
    });

    // Simulate a network request or perform actual password reset logic here
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Mock successful response
      if (_phoneController.text.isNotEmpty && _phoneController.text.length == 10) {
        // Navigate to VerifyOtpPage if phone number is valid
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(), // Navigate to the OTP page
          ),
        );
      } else {
        setState(() {
          _errorMessage = "Please enter a valid 10-digit phone number";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get the screen width

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
                  'Forgot Password?',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.concolor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please enter your Phone Number to receive a verification code',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
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
                    // Centered Circle Button with Shadow
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
                          backgroundColor: Color(0xFFFFFFFF),
                          child: IconButton(
                            icon: Icon(
                              Icons.lock,
                              color: Color(0xFF7E1416),
                              size: 40,
                            ),
                            onPressed: () {
                              // Perform action here, if any
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    // Label for the Phone Number
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Phone Number',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Phone Number Input Field
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10), // Limit input to 10 digits
                        FilteringTextInputFormatter.digitsOnly, // Allow digits only
                      ],
                    ),
                    SizedBox(height: 20),

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
                        onPressed: _isLoading ? null : _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF910002),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          minimumSize: Size(screenWidth, 56), // Set the width to match screen width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'Send',
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
    _phoneController.dispose();
    super.dispose();
  }
}
