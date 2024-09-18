import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'Constant.dart';
import 'face_recognition_walkthrough.dart';




class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  _WalkthroughPageState createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  final PageController _controller = PageController(); // PageController defined here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              Walkthrough1(controller: _controller), // Pass the controller to pages if needed
              Walkthrough2(controller: _controller),
              Walkthrough3(controller: _controller), // Pass the controller here as well
            ],
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3, // Number of pages
                effect: WormEffect(
                  dotColor: Colors.white,
                  activeDotColor: AppColors.concolor,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Walkthrough1 extends StatelessWidget {
  final PageController controller;

  const Walkthrough1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.18, -0.98),
          end: Alignment(0.18, 0.98),
          colors: [Color(0xFFD28F91), Colors.white],
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: screenHeight * 0.4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Manage Your ',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Tasks',
                                  style: GoogleFonts.montserrat(
                                    color: AppColors.concolor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1.0),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Effortlessly',
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    SizedBox(
                      width: screenWidth * 0.85,
                      child: Text(
                        'Organize your day by adding your\nown tasks or handling\nthose assigned to you.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Color(0xFF777777),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  margin: EdgeInsets.only(bottom: 100.0),
                  width: screenWidth * 0.85,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
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
                      'NEXT',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 16,
            child: TextButton(
              onPressed: () {
                // Navigate to the last page or skip to home screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FaceRecognitionWalkthroughPage(),
                  ),
                ); // Example to skip to the last page
              },
              child: Text(
                'Skip',
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Example pages to demonstrate the page view
class Walkthrough2 extends StatelessWidget {
  final PageController controller; // Accept PageController

  const Walkthrough2({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.18, -0.98),
          end: Alignment(0.18, 0.98),
          colors: [Color(0xFFD28F91), Colors.white],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: screenHeight * 0.4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: screenWidth * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Stay On Track with  ',
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Notifications',
                          style: GoogleFonts.montserrat(
                            color: AppColors.concolor,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                SizedBox(
                  width: screenWidth * 0.85,
                  child: Text(
                    'Receive reminders for upcoming\tasks and notifications for tasks\assigned to you',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Color(0xFF777777),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 100.0),
              width: screenWidth * 0.85,
              child: ElevatedButton(
                onPressed: () {
                  controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
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
                  'NEXT',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Walkthrough3 extends StatelessWidget {
  final PageController controller; // Accept PageController

  const Walkthrough3({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.18, -0.98),
          end: Alignment(0.18, 0.98),
          colors: [Color(0xFFD28F91), Colors.white],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: screenHeight * 0.4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: screenWidth * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Monitor Your',
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' Progress',
                              style: GoogleFonts.montserrat(
                                color: AppColors.concolor,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' and',
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Achievements',
                          style: GoogleFonts.montserrat(
                            color: AppColors.concolor,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                SizedBox(
                  width: screenWidth * 0.85,
                  child: Text(
                    "View completed tasks and monitor\your progress to see how much\you've achieved",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Color(0xFF777777),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 100.0),
              width: screenWidth * 0.85,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FaceRecognitionWalkthroughPage(),
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
                  'Get started',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
