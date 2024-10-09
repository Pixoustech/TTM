import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Constant.dart';
import 'NewPassword_page.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final List<TextEditingController> _otpControllers =
  List.generate(4, (_) => TextEditingController());
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;
  bool _canResend = true; // Flag to manage resend button state
  int _countdown = 10; // Countdown timer
  late final Timer _timer; // Timer for countdown

  @override
  void initState() {
    super.initState();
  }

  void _verifyOtp() {
    setState(() {
      _isLoading = true;
      _successMessage = null;
      _errorMessage = null;
    });

    // Simulate a network request or perform actual OTP verification logic here
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Mock successful response
      String otp = _otpControllers.map((controller) => controller.text).join();
      if (otp.length == 4) {
        setState(() {
          _successMessage = "OTP verification successful!"; // Updated success message
        });
        // Navigate to NewPasswordPage
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CreateNewPasswordPage()),
        );
      } else {
        setState(() {
          _errorMessage = "Please enter a valid 4-digit OTP"; // Updated error message
        });
      }
    });
  }

  void _resendOtp() {
    if (_canResend) {
      setState(() {
        _canResend = false; // Disable the resend button
        _countdown = 10; // Reset countdown
      });

      // Start countdown timer
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_countdown > 0) {
          setState(() {
            _countdown--;
          });
        } else {
          timer.cancel();
          setState(() {
            _canResend = true; // Enable the resend button
          });
        }
      });

      // Simulate sending OTP again (Add your OTP sending logic here)
      print('Resending OTP...');
    }
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
                  'Verify your Phone Number',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.concolor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please enter your 4 digit code sent to your phone number',
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
                    // Centered Circle Button with Shadow and Red Message Icon
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
                          child: Icon(
                            Icons.message,
                            color: AppColors.concolor, // Red color for the message icon
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    // OTP label
                    Text(
                      "OTP",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10), // Add some space between label and input fields

                    // Row for OTP inputs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 50,
                          child: TextField(
                            controller: _otpControllers[index],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1, // Limit to one character
                            buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) {
                              return null; // Hide the character count
                            },
                            onChanged: (value) {
                              if (value.length == 1 && index < 3) {
                                FocusScope.of(context).nextFocus(); // Move to next field
                              }
                              if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus(); // Move to previous field
                              }
                            },
                          ),
                        );
                      }),
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
                        onPressed: _isLoading ? null : _verifyOtp,
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
                          'Verify',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Resend OTP section
// Resend OTP section
                    if (!_canResend) ...[
                      Text(
                        'Resend OTP in $_countdown seconds',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ] else ...[
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black, // Default color for the first part
                          ),
                          children: [
                            TextSpan(text: "Haven’t got the code? "),
                            TextSpan(
                              text: "Resend",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: [
                                      Color(0xFFBE898A),
                                      Color(0xFF910002),
                                    ],
                                  ).createShader(Rect.fromLTWH(0, 0, 200, 70)), // Gradient for the text
                              ),
                              recognizer: TapGestureRecognizer()..onTap = _resendOtp, // Make the resend text clickable
                            ),
                          ],
                        ),
                      ),
                    ],

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
    for (var controller in _otpControllers) {
      controller.dispose(); // Dispose of each OTP controller
    }
    _timer?.cancel(); // Cancel the timer if it's running
    super.dispose();
  }
}
