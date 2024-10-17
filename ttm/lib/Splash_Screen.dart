import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttm/walkthrough_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoTopToCenter;
  late Animation<double> _triangleLeftShift;
  late Animation<double> _welcomeTextFadeIn;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkFirstLaunch();
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _logoTopToCenter = Tween<double>(begin: 0.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _triangleLeftShift = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _welcomeTextFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('isFirstLaunch');

    await Future.delayed(const Duration(seconds: 3));

    if (isFirstLaunch == null || isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WalkthroughPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.18, -0.98),
            end: Alignment(0.18, 0.98),
            colors: [Color(0xFFD28F91), Colors.white],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double logoLeftPosition =
                MediaQuery.of(context).size.width / 2 - 150;

            // Calculate triangle's current left position
            double triangleCurrentPosition =
                MediaQuery.of(context).size.width * _triangleLeftShift.value;

            // Check if triangle is near the logo
            if (triangleCurrentPosition < logoLeftPosition + 150 &&
                triangleCurrentPosition > logoLeftPosition - 10) {
              // Move logo 60px left if triangle is near and stop triangle movement
              logoLeftPosition -= 60;
              _triangleLeftShift = Tween<double>(begin: 0.4, end: 0.4).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeInOut,
                ),
              );
            }

            // Triangle padding
            double trianglePadding = -18.0; // Adjust this value as needed

            // Calculate the top position for the welcome message below the triangle
            double triangleTopPosition =
                MediaQuery.of(context).size.height * 0.5 + trianglePadding; // Add padding to the triangle's top position
            double welcomeMessageTopPosition =
                triangleTopPosition + 20; // Add some space below the triangle

            return Stack(
              children: [
                // Logo animation
                Positioned(
                  top: MediaQuery.of(context).size.height * _logoTopToCenter.value,
                  left: logoLeftPosition, // Use calculated left position
                  child: Container(
                    width: 300,
                    height: 300,
                    child: Image.asset('Assets/Images/TTM.png'),
                  ),
                ),
                // Triangle animation with padding
                Positioned(
                  top: triangleTopPosition,
                  left: triangleCurrentPosition,
                  child: ClipPathGroup(),
                ),
                // Welcome message positioned below the triangle
                Positioned(
                  top: welcomeMessageTopPosition, // Position below the triangle
                  left: (MediaQuery.of(context).size.width / 2) - 40,
                  child: Opacity(
                    opacity: _welcomeTextFadeIn.value,
                    child: Text(
                      'Task Tracking Management',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ClipPathGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.rotate(
          angle: 3.14,
          child: ClipPath(
            clipper: RightTriangleClipper(),
            child: Container(
              width: 200.0,
              height: 10.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE05F71),
                    Color(0xFFD2858A),
                    Color(0xFFBBA8A6),
                    Color(0xFFC9C6C6),
                  ],
                  stops: [0.0, 0.33, 0.66, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RightTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, size.height / 2);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
