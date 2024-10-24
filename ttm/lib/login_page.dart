import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttm/Splash_Screen.dart';
import 'Constant.dart';
import 'ForgotPasswordPage.dart';
import 'Navigation_page.dart';

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
  FocusNode _usernameFocusNode = FocusNode(); // Focus node for username field
  FocusNode _passwordFocusNode = FocusNode(); // Focus node for password field

  @override
  void initState() {
    super.initState();
    // Add listeners to focus nodes to rebuild when focus changes
    _usernameFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose(); // Dispose the focus nodes
    _passwordFocusNode.dispose();
    _usernameController.dispose(); // Dispose the text controllers
    _passwordController.dispose();
    super.dispose();
  }

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

      if (_usernameController.text == "" && _passwordController.text == "") {
        // If login is successful, navigate to the next page (e.g., home page)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Navigation()), // Directly push the ForgotPasswordPage
        );
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
        preferredSize: const Size.fromHeight(200.0), // Set your desired height here
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0), // Adjust vertical padding to move the container up
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
                    // Username text field with hint
                    TextField(
                      focusNode: _usernameFocusNode, // Set the focus node
                      controller: _usernameController,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black, // Set text color to black
                      ),
                      cursorColor: AppColors.concolor,
                      decoration: InputDecoration(
                        labelText: 'Username', // Use labelText for a floating label effect
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _usernameFocusNode.hasFocus || _usernameController.text.isNotEmpty ? Colors.black : Colors.grey, // Change color based on focus or if text is not empty
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder( // Define the focused border
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.concolor, // Change border color when focused
                            width: 2.0, // Set the width of the border
                          ),
                        ),
                        enabledBorder: OutlineInputBorder( // Define the enabled border
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey, // Color of the border when not focused
                            width: 1.0, // Set the width of the border
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    // Password text field with hint
// Password text field with hint
                    TextField(
                      focusNode: _passwordFocusNode, // Set the focus node
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible, // Toggle visibility
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black, // Set text color to black when typing
                      ),
                      cursorColor: AppColors.concolor,
                      decoration: InputDecoration(
                        labelText: 'Password', // Add floating label
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _passwordFocusNode.hasFocus || _passwordController.text.isNotEmpty
                              ? Colors.black
                              : Colors.grey, // Change color based on focus
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder( // Define the focused border
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.concolor, // Change border color when focused
                            width: 2.0, // Set the width of the border
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: AppColors.concolor,
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

// Increased space between the password field and "Use Face ID" toggle
                    SizedBox(height: 10), // Increased from 20 to 40 to add more space
// Use Face ID toggle and Forgot password row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FlutterSwitch(
                              width: 35.0,
                              height: 17.0,
                              value: _useFaceId,
                              borderRadius: 10.0, // Rounded corners
                              padding: 2.0,
                              activeColor: AppColors.concolor,
                              inactiveColor: Colors.grey,
                              toggleSize: 13.0, // Size of the toggle handle
                              onToggle: (value) {
                                setState(() {
                                  _useFaceId = value;
                                });
                              },
                            ),
                            SizedBox(width: 10),
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
                          onTap: _navigateToForgotPassword,
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.concolor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.concolor, // Set the button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        'Login',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
