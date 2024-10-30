import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import for secure storage
import 'package:local_auth/local_auth.dart'; // Import for biometric authentication
import 'package:ttm/Constant.dart';
import 'Login_Page/login_page.dart';
import 'Navigation_page.dart'; // Make sure you have this file

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _useFaceId = false; // Track Face ID toggle state
  bool _locationEnabled = false; // Track Location toggle state
  bool _notificationsEnabled = false; // Track Notifications toggle state
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadFaceIdPreference(); // Load Face ID preference when the profile page is initialized
    _attemptBiometricLogin(); // Attempt biometric login if Face ID is enabled
  }

  Future<void> _loadFaceIdPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _useFaceId = prefs.getBool('useFaceId') ?? false; // Load Face ID preference
    });
  }

  Future<void> _attemptBiometricLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool useFaceId = prefs.getBool('useFaceId') ?? false;

    if (useFaceId) {
      // Check if the device supports biometric authentication
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        // Attempt to authenticate
        bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to log in',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (authenticated) {
          // If authentication is successful, retrieve stored credentials
          String? username = await secureStorage.read(key: 'username');
          String? password = await secureStorage.read(key: 'password');

          // Perform login with stored credentials
          if (username != null && password != null) {
            // Call your login method here with the stored credentials
            // Assuming you have a method to handle login
            // await _apiService.login(username, password);
            // Navigate to the next screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Navigation()),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backwhite,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.concolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUserProfile(),
              SizedBox(height: 20),
              _buildEditProfileBox(context),
              SizedBox(height: 10),
              _buildStatisticBox(context),
              SizedBox(height: 10),
              _buildChangePassBox(context),
              SizedBox(height: 10),
              _buildEnableFaceIDBox(context),
              SizedBox(height: 10),
              _buildLocationBox(context),
              SizedBox(height: 10),
              _buildNotificationBox(context),
              SizedBox(height: 10),
              _buildLogoutBox(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        Stack(
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
                radius: 45,
                backgroundColor: Colors.grey[200],
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'John Doe',
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'john.doe@example.com',
          style: GoogleFonts.montserrat(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildEditProfileBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle Edit Profile action
      },
      child: _buildProfileBox(
        context,
        Icons.edit,
        'Edit Profile',
      ),
    );
  }

  Widget _buildStatisticBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle Statistic action
      },
      child: _buildProfileBox(
        context,
        Icons.pie_chart,
        'Statistic',
      ),
    );
  }

  Widget _buildChangePassBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle Change Password action
      },
      child: _buildProfileBox(
        context,
        Icons.lock,
        'Change Password',
      ),
    );
  }

  Widget _buildProfileBox(BuildContext context, IconData icon, String title, {Color textColor = Colors.black}) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.concolor),
              SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.montserrat(fontSize: 16, color: textColor), // Use the passed text color
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, color: AppColors.concolor), // Arrow icon
        ],
      ),
    );
  }

  Widget _buildEnableFaceIDBox(BuildContext context) {
    return _buildToggleBox(
      context,
      Icons.emoji_emotions,
      'Enable Face ID',
      _useFaceId,
          (value) {
        setState(() {
          _useFaceId = value; // Update toggle state
        });
        _saveFaceIdPreference(value); // Save Face ID preference
      },
    );
  }

  Widget _buildLocationBox(BuildContext context) {
    return _buildToggleBox(
      context,
      Icons.location_on,
      'Turn on Location',
      _locationEnabled,
          (value) {
        setState(() {
          _locationEnabled = value; // Update toggle state
        });
      },
    );
  }

  Widget _buildNotificationBox(BuildContext context) {
    return _buildToggleBox(
      context,
      Icons.notifications,
      'Notification',
      _notificationsEnabled,
          (value) {
        setState(() {
          _notificationsEnabled = value; // Update toggle state
        });
      },
    );
  }

  Widget _buildToggleBox(BuildContext context, IconData icon, String title, bool value, Function(bool) onToggle) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.concolor),
              SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.montserrat(fontSize: 16),
              ),
            ],
          ),
          FlutterSwitch(
            width: 35.0,
            height: 17.0,
            value: value,
            borderRadius: 10.0,
            padding: 2.0,
            activeColor: AppColors.concolor,
            inactiveColor: Colors.grey,
            toggleSize: 13.0,
            onToggle: onToggle, // Handle toggle change
          ),
        ],
      ),
    );
  }

  // Logout Box
  Widget _buildLogoutBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showLogoutConfirmationDialog(context); // Show confirmation dialog
      },
      child: _buildProfileBox(
        context,
        Icons.logout,
        'Logout',
        textColor: Colors.red,
      ),
    );
  }

  // Method to show the logout confirmation dialog
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to exit
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                logout(context); // Call the logout method
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Method to handle logout
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken'); // Remove token to log the user out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Method to save Face ID preference
  Future<void> _saveFaceIdPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useFaceId', value); // Save Face ID preference
  }
}