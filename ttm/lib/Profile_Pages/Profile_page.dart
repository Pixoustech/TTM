import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Comman_pages/Constant.dart';
import '../Login_Page/login_page.dart';
import 'ChangePasswordPage.dart';
import 'MyProfilePage.dart';
import '../Comman_pages/Navigation_page.dart'; // Ensure you have this file

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _useFaceId = false; // Track Face ID toggle state
  bool _locationEnabled = false; // Track Location toggle state
  bool _notificationsEnabled = false; // Track Notifications toggle state
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Load preferences when the profile page is initialized
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _useFaceId = prefs.getBool('useFaceId') ?? false; // Load Face ID preference
      _locationEnabled = prefs.getBool('locationEnabled') ?? false; // Load Location preference
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false; // Load Notifications preference
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backwhite,
      appBar: AppBar(
        backgroundColor: AppColors.concolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.backwhite),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Navigation()),
            );
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Profile',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backwhite,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUserProfile(),
              SizedBox(height: 20),
              _buildMyProfileBox(context),
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
  Widget _buildMyProfileBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyProfilePage()), // Navigate to My Profile Page
        );
      },
      child: _buildProfileBox(
        context,
        Icons.person,
        'My Profile',
      ),
    );
  }

  Widget _buildChangePassBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordPage()), // Navigate to Change Password Page
        );
      },
      child: _buildProfileBox(
        context,
        Icons.lock,
        'Change Password',
      ),
    );
  }

  Widget _buildProfileBox(BuildContext context, IconData icon, String title, {Color textColor = Colors.black})
  {
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
        _saveLocationPreference(value); // Save Location preference
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
        _saveNotificationPreference(value); // Save Notification preference
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



  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to exit
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Logout',
            style: GoogleFonts.montserrat(), // Use Montserrat font
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.montserrat(), // Use Montserrat font
          ),
          actions: [
            // Use Row to arrange buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between buttons
              children: [
                // Cancel Button
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 8.0),
                    // Add margin to the right
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.concolor, width: 1), // Set the border color and width
                      borderRadius: BorderRadius.circular(11), // Match the border radius with the button
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(// Set the background color
                        foregroundColor: AppColors.concolor, // Set the text color to white
                        padding: EdgeInsets.symmetric(vertical: 16), // Optional: add padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11), // Box shape (sharp corners)
                        ),
                      ),
                      child: Text('Cancel', style: GoogleFonts.montserrat()), // Use Montserrat font
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ),
                ),
                // Confirm Button
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0), // Add margin to the left
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.concolor, // Set the background color
                        foregroundColor: Colors.white, // Set the text color to white
                        padding: EdgeInsets.symmetric(vertical: 16), // Optional: add padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11), // Box shape (sharp corners)
                        ),
                      ),
                      child: Text('Confirm', style: GoogleFonts.montserrat()), // Use Montserrat font
                      onPressed: () {
                        logout(context); // Call the logout method
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Method to handle logout
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool useFaceId = prefs.getBool('useFaceId') ?? false;

    if (!useFaceId) {
      await prefs.remove('userToken'); // Remove token to log the user out
      await secureStorage.delete(key: 'username'); // Clear username
      await secureStorage.delete(key: 'password'); // Clear password
    } else {
      await prefs.remove('userToken'); // Remove token to log the user out
      String? username = await secureStorage.read(key: 'username');
      String? password = await secureStorage.read(key: 'password');

      if (username != null && password != null) {
        // Optionally handle auto-login
      }
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }
  // Method to save Face ID preference
  Future<void> _saveFaceIdPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useFaceId', value); // Save Face ID preference
  }

  // Method to save Location preference
  Future<void> _saveLocationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('locationEnabled', value); // Save Location preference
  }

  // Method to save Notification preference
  Future<void> _saveNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value); // Save Notification preference
  }
}
class AuthService {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to exit
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Logout',
            style: GoogleFonts.montserrat(), // Use Montserrat font
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.montserrat(), // Use Montserrat font
          ),
          actions: [
            // Use Row to arrange buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between buttons
              children: [
                // Cancel Button
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 8.0),
                    // Add margin to the right
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.concolor, width: 1), // Set the border color and width
                      borderRadius: BorderRadius.circular(11), // Match the border radius with the button
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(// Set the background color
                        foregroundColor: AppColors.concolor, // Set the text color to white
                        padding: EdgeInsets.symmetric(vertical: 16), // Optional: add padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11), // Box shape (sharp corners)
                        ),
                      ),
                      child: Text('Cancel', style: GoogleFonts.montserrat()), // Use Montserrat font
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ),
                ),
                // Confirm Button
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0), // Add margin to the left
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.concolor, // Set the background color
                        foregroundColor: Colors.white, // Set the text color to white
                        padding: EdgeInsets.symmetric(vertical: 16), // Optional: add padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11), // Box shape (sharp corners)
                        ),
                      ),
                      child: Text('Confirm', style: GoogleFonts.montserrat()), // Use Montserrat font
                      onPressed: () {
                        logout(context); // Call the logout method
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool useFaceId = prefs.getBool('useFaceId') ?? false;

    if (!useFaceId) {
      await prefs.remove('userToken'); // Remove token to log the user out
      await secureStorage.delete(key: 'username'); // Clear username
      await secureStorage.delete(key: 'password'); // Clear password
    } else {
      await prefs.remove('userToken'); // Remove token to log the user out
      String? username = await secureStorage.read(key: 'username');
      String? password = await secureStorage.read(key: 'password');

      if (username != null && password != null) {
        // Optionally handle auto-login
      }
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }
}