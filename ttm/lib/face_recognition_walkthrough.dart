import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the google_fonts package

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0), // Increase the height of the AppBar to 200
        child: AppBar(
          backgroundColor: Color(0xFF7E1416), // Set the AppBar color
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
          children: [
            // Image moved to the top
            Padding(
              padding: const EdgeInsets.only(top: 16.0), // Adjust the top padding
              child: Center(
                child: Image.asset(
                  'Assets/Images/face1.png', // Replace with your image asset path
                  width: 150, // Adjust width as needed
                  height: 150, // Adjust height as needed
                  fit: BoxFit.cover, // Adjust fit as needed
                ),
              ),
            ),
            SizedBox(height: 20), // Add some space between the image and the text
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Login with Face ID', // New text here
                style: GoogleFonts.montserrat( // Use Montserrat from Google Fonts
                  fontSize: 24,
                  color: Color(0xFF7E1416),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
