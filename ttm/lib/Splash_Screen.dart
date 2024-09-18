import 'package:flutter/material.dart';
import 'walkthrough_page.dart'; // Import the walkthrough page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for the splash screen
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the WalkthroughPage after the splash screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WalkthroughPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo or any splash content here
            Image.asset('Assets/Images/TTM.png', height: 150, width: 150), // Replace with your logo
            const SizedBox(height: 20),
            const Text(
              'Welcome to My App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
