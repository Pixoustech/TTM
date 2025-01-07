import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ttm/Comman_pages/Constant.dart';
import '../Calender_page/Calender_page.dart';
import '../Home_Page/Home_page.dart';
import '../Report_page/Report_Page.dart';
import '../Event_Create_pages/Task_Page.dart';
import '../Location_pages/locationMap_google.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _bottomNavIndex = 0; // To track the selected index

  // Define a list of pages
  final List<Widget> _pages = [
    HomePage(),        // Home Page
    CalendarPage(),    // Calendar Page
    const CreateEvent(), // Add Task Page
    MapPage(),         // Map Page
    const ReportPage(), // Report Page
  ];

  // Define your icon list
  final List<IconData> iconList = [
    Icons.home,
    Icons.calendar_today_rounded,
    Icons.add_circle,
    Icons.map_rounded,
    Icons.pie_chart,
  ];

  // Method to get icon color based on selection
  Color _getIconColor(int index) {
    return _bottomNavIndex == index ? AppColors.concolor : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Page content based on the selected index
      body: _pages[_bottomNavIndex],

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Curved Navigation Bar
      bottomNavigationBar: CurvedNavigationBar(
        index: _bottomNavIndex,
        height: 60.0,
        items: iconList
            .asMap()
            .entries
            .map((entry) => Icon(
          entry.value,
          size: 30,
          color: _getIconColor(entry.key), // Set icon color based on selection
        ))
            .toList(),
        color: Color(0xFFF6E0E0),
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}