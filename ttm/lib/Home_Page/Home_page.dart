import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure to import Google Fonts
import 'package:ttm/Constant.dart';

import '../Widgets_page.dart';
import 'Home_page_Widgets.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String buttonText = "Check In";
  String _selectedButton = '';

  void _toggleCheckInOut() {
    setState(() {
      buttonText = (buttonText == "Check In") ? "Check Out" : "Check In";
    });
    print("$buttonText button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient Background Container
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFBE898A),
                    Color(0xFFFFFFFF),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.6],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0), // Set vertical padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'Assets/Images/TTMlogo.png',
                          height: 80,
                          width: 100,
                        ),
                        IconButton(
                          icon: Icon(Icons.account_circle, size: 40, color: AppColors.concolor),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning, John Harry M',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF505050),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Let’s get to work!",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _toggleCheckInOut,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.concolor,
                              minimumSize: const Size(double.infinity, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                buttonText,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Search Box
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFBE898A),
                                    Color(0xFFFFE8E8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Container(
                                height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: TextField(
                                  cursorColor: AppColors.concolor,
                                  style: GoogleFonts.montserrat(
                                    color: AppColors.concolor,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search, color: AppColors.concolor),
                                    hintText: 'Search',
                                    hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            // White Background Container
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildFilterButton('Previous', _selectedButton, () {
                          setState(() {
                            _selectedButton = 'Previous';
                          });
                        }),
                        const SizedBox(width: 10),
                        buildFilterButton('Today', _selectedButton, () {
                          setState(() {
                            _selectedButton = 'Today';
                          });
                        }),
                        const SizedBox(width: 10),
                        buildFilterButton('Upcoming', _selectedButton, () {
                          setState(() {
                            _selectedButton = 'Upcoming';
                          });
                        }),
                      ],
                    ),
                    AppWidgets.divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: buildTaskBox('Not Started', Colors.grey, double.infinity, 90, 5, Icons.pending),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: buildTaskBox('In Progress', Colors.orange, double.infinity, 90, 10, Icons.rotate_left),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: buildTaskBox('Completed', Colors.green, double.infinity, 90, 10, Icons.check_circle),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: buildTaskBox('Overdue', Color(0xFFC52D28), double.infinity, 90, 5, Icons.timer),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF505050),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'You have 3 Tasks Today',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 190,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                buildTaskDetailBox(
                                  'App Design',
                                  'The current website design needs a refresh to improve user experience and enhance visual appeal.',
                                  Colors.white,
                                  'High',
                                  'In Progress',
                                  DateTime.now(),
                                  'New York',
                                ),
                                const SizedBox(width: 10),
                                buildTaskDetailBox(
                                  'App Development',
                                  'The current website design needs a refresh to improve user experience and enhance visual appeal.......',
                                  Colors.white,
                                  'Medium',
                                  'Overdue',
                                  DateTime.now().add(Duration(days: -2)),
                                  'San Francisco',
                                ),
                                const SizedBox(width: 10),
                                buildTaskDetailBox(
                                  'Testing',
                                  'The current website design needs a refresh to improve user experience and enhance visual appeal',
                                  Colors.white,
                                  'Low',
                                  'Completed',
                                  DateTime.now().add(Duration(days: -1)),
                                  'Los Angeles',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Meeting',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF505050),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'You have 2 Meetings Today',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 1),
                          // Wrap the Column in a SingleChildScrollView if needed
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                // Meeting Detail Box
                                buildMeetingDetailBox(
                                  'App Design Meeting',
                                  'The current website design needs a refresh to improve user experience and enhance visual appeal.',
                                  Colors.white,
                                  'Medium',
                                  'In Progress',
                                  DateTime(2024, 10, 25),  // From Date
                                  DateTime(2024, 10, 26),  // To Date
                                  '10:00 AM',              // From Time
                                  '12:00 PM',              // To Time
                                  'New York',
                                ),
                                const SizedBox(height: 0), // Space between boxes

                                // Meeting Detail Box
                                buildMeetingDetailBox(
                                  'App Design Meeting',
                                  'The current website design needs a refresh to improve user experience and enhance visual appeal.',
                                  Colors.white,
                                  'Low',
                                  'Not started',
                                  DateTime(2024, 10, 25),  // From Date
                                  DateTime(2024, 10, 26),  // To Date
                                  '10:00 AM',              // From Time
                                  '12:00 PM',              // To Time
                                  'New York',
                                ),
                                const SizedBox(height: 0), // Space between boxes

                                // Meeting Detail Box
                                buildMeetingDetailBox(
                                  'App Design Meeting',
                                  'The current website design needs a refresh to improve user experience and enhance visual appeal.',
                                  Colors.white,
                                  'High',
                                  'Completed',
                                  DateTime(2024, 10, 25),  // From Date
                                  DateTime(2024, 10, 26),  // To Date
                                  '10:00 AM',              // From Time
                                  '12:00 PM',              // To Time
                                  'New York',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}