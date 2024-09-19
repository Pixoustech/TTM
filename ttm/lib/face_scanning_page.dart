import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'Constant.dart';

class Facescanning extends StatefulWidget {
  @override
  _FacescanningState createState() => _FacescanningState();
}

class _FacescanningState extends State<Facescanning> with SingleTickerProviderStateMixin {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> _cameras;
  late CameraDescription _currentCamera;
  late FaceDetector _faceDetector;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
    _initializeFaceDetector();
    // Set up the periodic image processing
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      _processImage();
    });
  }

  Future<void> _initializeCameras() async {
    _cameras = await availableCameras();
    _currentCamera = _cameras.first;
    _controller = CameraController(_currentCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  Future<void> _initializeFaceDetector() async {
    final options = FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableTracking: true,
    );
    _faceDetector = GoogleMlKit.vision.faceDetector(options);
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    _timer?.cancel(); // Cancel the timer when disposing
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

  Future<void> _processImage() async {
    try {
      final image = await _controller.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);

      // Ensure _faceDetector is initialized
      await _initializeFaceDetector();

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NextPage()),
        );
      }
    } catch (e) {
      print('Error processing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.18, -0.98),
              end: Alignment(0.18, 0.98),
              colors: [Color(0xFFD28F91), Colors.white],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Face Verification',
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.concolor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Text(
                      'Please put your phone in front of your face to log in',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onDoubleTap: _switchCamera,
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Transform.scale(
                    scaleX: -1,
                    child: CameraPreview(_controller),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text('Welcome to the next page!'),
      ),
    );
  }
}
