import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'Constant.dart'; // Import your constants file

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Facescanning(),
    );
  }
}

class Facescanning extends StatefulWidget {
  @override
  _FacescanningState createState() => _FacescanningState();
}

class _FacescanningState extends State<Facescanning> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> _cameras;
  late CameraDescription _currentCamera;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    _cameras = await availableCameras();
    _currentCamera = _cameras.first; // Default to the first camera (usually the back camera)
    _controller = CameraController(_currentCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchCamera() async {
    final newCamera = _cameras.firstWhere(
          (camera) => camera != _currentCamera,
      orElse: () => _currentCamera,
    );
    if (newCamera != _currentCamera) {
      setState(() {
        _currentCamera = newCamera;
        _controller = CameraController(_currentCamera, ResolutionPreset.medium);
        _initializeControllerFuture = _controller.initialize();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0), // Increase the height of the AppBar to 200
        child: AppBar(
          backgroundColor: AppColors.concolor, // Set the AppBar color
          elevation: 0, // Remove shadow
          flexibleSpace: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Face Verification', // Main title text
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // Text color
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10), // Space between title and description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Please put your phone in front of your face to log in', // Description text
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onDoubleTap: _switchCamera,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between content and bottom
            children: [
              Expanded(
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CameraPreview(_controller),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              // Button at the bottom
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05), // Padding is 5% of screen width
                child: Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.05), // Bottom margin is 5% of screen height
                  width: screenWidth * 0.85, // Button width is 85% of screen width
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement face scanning functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.concolor,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02), // Vertical padding is 2% of screen height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03), // Border radius is 3% of screen width
                      ),
                    ),
                    child: Text(
                      'Start Scanning',
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
      ),
    );
  }
}
