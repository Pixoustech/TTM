import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Calender_page/Calender_page.dart';
import 'Constant.dart';
import '../Home_Page/Home_page.dart';
import '../Report_page/Report_Page.dart';
import '../Event_Create_pages/Task_Page.dart';
import '../Location_pages/locationMap_google.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<Navigation> {
  int _selectedIndex = 0; // To track the selected index

  // Define a list of pages
  final List<Widget> _pages = [
    HomePage(),        // Home Page
    CalendarPage(),    // Calendar Page
    Createevent(),     // Add Task Page
    MapPage(),         // Map Page
    ReportPage(),     // Profile Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent, // Set background color to transparent
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0 ? AppColors.concolor : Colors.black,
              padding: EdgeInsets.zero, // Remove padding
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today_rounded),
              onPressed: () => _onItemTapped(1),
              color: _selectedIndex == 1 ? AppColors.concolor : Colors.black,
              padding: EdgeInsets.zero, // Remove padding
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, size: 50), // Center plus icon
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2 ? AppColors.concolor : AppColors.concolor,
              padding: EdgeInsets.zero, // Remove padding
            ),
            IconButton(
              icon: const Icon(Icons.map_rounded),
              onPressed: () => _onItemTapped(3),
              color: _selectedIndex == 3 ? AppColors.concolor : Colors.black,
              padding: EdgeInsets.zero, // Remove padding
            ),
            IconButton(
              icon: const Icon(Icons.pie_chart),
              onPressed: () => _onItemTapped(4),
              color: _selectedIndex == 4 ? AppColors.concolor : Colors.black,
              padding: EdgeInsets.zero, // Remove padding
            ),
          ],
        ),
      ),
    );
  }
}
