import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttm/Constant.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _useFaceId = false; // Track Face ID toggle state
  bool _locationEnabled = false; // Track Location toggle state
  bool _notificationsEnabled = false; // Track Notifications toggle state

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
              // Profile Picture at the Center
              _buildUserProfile(),
              SizedBox(height: 20),

              // Edit Profile Box
              _buildEditProfileBox(context),
              SizedBox(height: 10),

              // Statistic Profile Box
              _buildStatisticBox(context),
              SizedBox(height: 10),

              // Change Password Profile Box
              _buildChangePassBox(context),
              SizedBox(height: 10),

              // Enable Face ID Profile Box
              _buildEnableFaceIDBox(context),
              SizedBox(height: 10),

              // Location Profile Box
              _buildLocationBox(context),
              SizedBox(height: 10),

              // Notification Profile Box
              _buildNotificationBox(context),
              SizedBox(height: 10),

              // Logout Box
              _buildLogoutBox(context),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create the user profile section
  Widget _buildUserProfile() {
    return Column(
      children: [
        // Outer Circle with Gradient Border
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer gradient border
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
            // Inner Circle with a solid background
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            // Inner CircleAvatar with padding
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

  // Function to create the Edit Profile box
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


  // Function to create the Enable Face ID box with a toggle button
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
      },
    );
  }

  // Function to create the LocationBox with a toggle button
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

  // Function to create the Notification Box with a toggle button
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

  // Helper function to create toggle boxes
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
        // Handle Logout action
      },
      child: _buildProfileBox(
        context,
        Icons.logout,
        'Logout',
        textColor: Colors.red,
      ),
    );
  }
}
