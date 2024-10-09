import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Constant.dart';
import 'ForgotPasswordPage.dart'; // Import your constants and other necessary files

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false; // Track password visibility
  bool _useFaceId = false; // Track Face ID toggle state

  void _login() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate a network request or perform actual login logic here
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      if (_usernameController.text == "admin" && _passwordController.text == "123") {
        // If login is successful, navigate to the next page (e.g., home page)
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = "Invalid username or password";
        });
      }
    });
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()), // Directly push the ForgotPasswordPage
    ); // Navigate to ForgotPasswordPage
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // Set the background of the entire scaffold to white
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0), // Set your desired height here
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFBE898A), // Gradient color 1
                  Colors.white, // Gradient color 2
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Set your desired background color here
        width: double.infinity, // Ensure the container takes the full width
        height: double.infinity, // Ensure the container takes the full height
        child: Stack(
          children: [
            // Login form overlay
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0), // Adjust vertical padding to move the container up
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start, // Align to start
                  children: [
                    Text(
                      'Log in to your account',
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.concolor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Access your account by logging in',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 30),
                    // Username label
                    Text(
                      'Username',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Password label
                    Text(
                      'Password',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible, // Toggle visibility
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility // Show icon when visible
                                : Icons.visibility_off, // Hide icon when hidden
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                            });
                          },
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: _useFaceId,
                              onChanged: (value) {
                                setState(() {
                                  _useFaceId = value; // Update the Face ID state
                                });
                              },
                            ),
                            Text(
                              'Use Face ID',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _navigateToForgotPassword, // Navigate to Forgot Password Page
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.concolor,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Login',
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
