import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart'; // Import for biometric authentication
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart'; // Import the API service
import 'model.dart';
import '../Comman_pages/Constant.dart';
import '../Password_pages/ForgotPasswordPage.dart';
import '../Comman_pages/Navigation_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Track password visibility
  bool _useFaceId = false; // Track Face ID toggle state
  final ApiService _apiService = ApiService(); // Create an instance of ApiService
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication(); // Local authentication instance

  @override
  void initState() {
    super.initState();
    _checkAutoLogin(); // Attempt auto-login if credentials are stored
  }

  @override
  void dispose() {
    _usernameController.dispose(); // Dispose the text controllers
    _passwordController.dispose();
    super.dispose();
  }

  void _checkAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool useFaceId = prefs.getBool('useFaceId') ?? false; // Check Face ID preference
    String? userId = await secureStorage.read(key: 'userId');

    if (useFaceId) {
      // Attempt biometric authentication
      bool isAuthenticated = await _authenticateWithBiometrics();

      if (isAuthenticated) {
        // If authentication is successful, attempt to auto-login using stored credentials
        String? username = await secureStorage.read(key: 'username');
        String? password = await secureStorage.read(key: 'password');

        if (username != null && password != null) {
          // Call the login method with stored credentials
          _usernameController.text = username; // Set the username in the controller
          _passwordController.text = password; // Set the password in the controller
          _login(); // Call the login method
        }
      }
    }
  }
  Future<bool> _authenticateWithBiometrics() async {
    try {
      // Check if biometrics can be checked
      final canCheckBiometrics = await auth.canCheckBiometrics;
      print('canCheckBiometrics: $canCheckBiometrics');

      if (!canCheckBiometrics) {
        print('Biometric authentication is not available.');
        return false;
      }

      // Get the available biometric types
      final availableBiometrics = await auth.getAvailableBiometrics();
      print('getAvailableBiometrics: $availableBiometrics');

        return await auth.authenticate(
          localizedReason: 'Please authenticate to log in using face recognition',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
    } catch (e) {
      print("Error during biometric authentication: $e");
      return false;
    }
  }


  void _loginWithStoredCredentials(String username, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserModel? user = await _apiService.login(username, password);

      if (user != null) {
        await _saveUserData(user);
        _navigateToHome();
      } else {
        _showSnackbar("Invalid credentials");
      }
    } catch (e) {
      _showSnackbar("An error occurred during login");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserModel? user = await _apiService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (user != null) {
        await _saveUserData(user);
        _navigateToHome();
      } else {
        _showSnackbar("Invalid credentials");
      }
    } catch (e) {
      _showSnackbar("An error occurred during login");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', user.accessToken);
    await prefs.setString('userId', user.userId);
    await prefs.setBool('useFaceId', _useFaceId); // Save Face ID preference
    await secureStorage.write(key: 'username', value: _usernameController.text);
    await secureStorage.write(key: 'password', value: _passwordController.text);
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Navigation()),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: AppBar(
          flexibleSpace: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFBE898A),
                      Colors.white,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                'Assets/Images/TTMlogo.png', // Replace with your logo's path
                height: MediaQuery.of(context).size.height * 0.1, // 10% of screen height
                width: MediaQuery.of(context).size.width * 0.5, // 50% of screen width (optional)
                fit: BoxFit.contain, // Adjust how the logo fits
              ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    TextField(
                      controller: _usernameController,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      cursorColor: AppColors.concolor,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
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
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      cursorColor: AppColors.concolor,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: AppColors.concolor,
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FlutterSwitch(
                              width: 35.0,
                              height: 17.0,
                              value: _useFaceId,
                              borderRadius: 10.0,
                              padding: 2.0,
                              activeColor: AppColors.concolor,
                              inactiveColor: Colors.grey,
                              toggleSize: 13.0,
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
                        backgroundColor: AppColors.concolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text (
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
