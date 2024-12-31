import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Comman_pages/Constant.dart';
import 'Verify_OTP_page.dart';
import 'Otp_Service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode(); // Define the phone focus node
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneFocusNode.dispose(); // Dispose the focus node when the widget is destroyed
    _phoneController.dispose(); // Dispose the text controller
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final mobileNumber = _phoneController.text.trim();

    if (mobileNumber.isEmpty || mobileNumber.length != 10) {
      setState(() {
        _errorMessage = "Please enter a valid 10-digit phone number";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final otpService = OtpService();
      final response = await otpService.sendOtp(mobileNumber);

      if (response.success) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(mobileNumber: '9688888236'), // Pass the mobile number
          ),
        );
      } else {
        setState(() {
          _errorMessage = response.message ?? "Failed to send OTP";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: Column(
                  children: [
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
                          child: Icon(
                            Icons.lock,
                            color: AppColors.concolor,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Phone Number text field with validation
                    TextField(
                      focusNode: _phoneFocusNode, // Attach the focus node here
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _phoneFocusNode.hasFocus || _phoneController.text.isNotEmpty
                              ? Colors.black
                              : Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.concolor,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                    ],
                    ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.concolor,
    padding: EdgeInsets.symmetric(vertical: 16.0),
    minimumSize: Size(screenWidth, 56), // Set the width to match screen width
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Send OTP',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
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
}
