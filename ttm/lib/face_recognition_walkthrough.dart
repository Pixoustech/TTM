import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Constant.dart';
import 'face_scanning_page.dart'; // Import the google_fonts package

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FaceRecognitionWalkthroughPage(),
    );
  }
}

class FaceRecognitionWalkthroughPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0), // Increase the height of the AppBar to 200
        child: AppBar(
          backgroundColor: AppColors.concolor, // Set the AppBar color
          elevation: 0, // Remove shadow
          flexibleSpace: Center(
            child: Container(
              width: 120, // Adjust the size of the logo
              height: 120, // Adjust the size of the logo
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/Images/TTM.png'), // Replace with your logo asset path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between content and bottom
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0), // Adjust the top padding
                  child: Center(
                    child: Image.asset(
                      'Assets/Images/face1.png', // Replace with your image asset path
                      width: 150, // Adjust width as needed
                      height: 150, // Adjust height as needed
                      fit: BoxFit.cover, // Adjust fit as needed
                    ),
                  ),
                ),
                SizedBox(height: 30), // Space between image and text
                Text(
                  'Login with Face ID', // Main title text
                  style: GoogleFonts.montserrat( // Use Montserrat from Google Fonts
                    fontSize: 24,
                    color: AppColors.concolor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16), // Space between title and bottom text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding
                  child: Text(
                    'Unlock your account quickly and securely with Face ID', // Bottom text
                    style: GoogleFonts.montserrat( // Use Montserrat from Google Fonts
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            // Button at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                margin: EdgeInsets.only(bottom: 100.0),
                width: screenWidth * 0.85, // Adjust button width based on screen width
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Facescanning (),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.concolor,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Scan my face',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04, // Adjust text size based on screen width
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
