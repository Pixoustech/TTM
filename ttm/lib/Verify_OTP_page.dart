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
  late final List<TextEditingController> _otpControllers;
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;
  bool _canResend = true;
  int _countdown = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(4, (_) => TextEditingController());
    _clearOtpFields(); // Only clear OTP when the page is first initialized
  }

  void _clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _successMessage = null;
      _errorMessage = null;
    });

    await Future.delayed(Duration(seconds: 2)); // Simulate network request

    setState(() {
      _isLoading = false;
    });

    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CreateNewPasswordPage()),
      );
    } else {
      setState(() {
        _errorMessage = "Please enter a valid 4-digit OTP";
      });
    }
  }

  void _resendOtp() {
    if (_canResend) {
      setState(() {
        _canResend = false;
        _countdown = 10;
      });

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdown > 0) {
            _countdown--;
          } else {
            timer.cancel();
            _canResend = true;
          }
        });
      });

      print('Resending OTP...');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: _buildAppBar(),
      ),
      body: _buildBody(screenWidth, isPortrait),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildBody(double screenWidth, bool isPortrait) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: isPortrait ? 5.0 : 10.0),
              child: Column(
                children: [
                  _buildMessageIcon(),
                  SizedBox(height: 40),
                  _buildOtpLabel(screenWidth),
                  SizedBox(height: 10),
                  _buildOtpInputs(screenWidth),
                  SizedBox(height: 20),
                  _buildMessages(),
                  SizedBox(height: 20),
                  _buildVerifyButton(screenWidth),
                  SizedBox(height: 20),
                  _buildResendOtpSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageIcon() {
    return Center(
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
            color: AppColors.concolor,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildOtpLabel(double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.06),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "OTP",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInputs(double screenWidth) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return SizedBox(
            width: screenWidth * 0.15,
            child: TextField(
              controller: _otpControllers[index],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              autofocus: index == 0, // Start focus on the first field
              buildCounter: (BuildContext context,
                  {int? currentLength, int? maxLength, bool? isFocused}) {
                return null;
              },
              onChanged: (value) {
                if (value.length == 1 && index < 3) {
                  // Move to the next field if the user types a number
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty && index > 0) {
                  // Go back to the previous field if the field is empty
                  FocusScope.of(context).previousFocus();
                }

                // Check if all fields are filled
                if (_otpControllers.every((controller) => controller.text.isNotEmpty)) {
                  // Hide the keyboard after the last digit is entered
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          );
        })
    );
  }

  Widget _buildMessages() {
    return Column(
      children: [
        if (_successMessage != null)
          Text(
            _successMessage!,
            style: TextStyle(color: Colors.green),
            textAlign: TextAlign.center,
          ),
        if (_errorMessage != null)
          Text(
            _errorMessage!,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildVerifyButton(double screenWidth) {
    return Center(
      child: ElevatedButton(
        onPressed: _isLoading ? null : _verifyOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.concolor,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          minimumSize: Size(screenWidth, 56),
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
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildResendOtpSection() {
    return Column(
      children: [
        Center(
          child: RichText(
            text: TextSpan(
              text: "Didn’t receive the OTP? ",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: 'Resend OTP',
                  style: GoogleFonts.montserrat(
                    color: _canResend ? AppColors.concolor : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (_canResend) {
                        _resendOtp();
                      }
                    },
                ),
              ],
            ),
          ),
        ),
        // New widget to display the countdown seconds
        if (!_canResend) // Only show if the countdown is active
          Padding(
            padding: const EdgeInsets.only(top: 10.0), // Space between messages
            child: Text(
              'Please wait for $_countdown seconds',
              style: GoogleFonts.montserrat(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.center, // Center the text
            ),
          ),
      ],
    );
  }


  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
