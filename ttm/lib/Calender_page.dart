import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart'; // Import the table_calendar package
import 'package:ttm/Constant.dart';
import 'Home_Page/Home_page.dart';
import 'Home_Page/Home_page_Widgets.dart';
import 'Navigation_page.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String _currentView = 'events'; // Default view is events
  DateTime _focusedDay = DateTime.now(); // Track the focused day

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.concolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.backwhite),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Navigation()),
            );
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Calendar',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backwhite,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add the titles for Events, Holidays, and Leaves at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _clickableTitle('Events'),
                _clickableTitle('Holidays'),
                _clickableTitle('Leave'),
              ],
            ),
            SizedBox(height: 10),
            _buildIndicators(),
            SizedBox(height: 16),
            // Custom header
            _buildCustomHeader(),
            SizedBox(height: 16),
            // Calendar widget with shadow
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Only show shadow at the bottom
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay; // Update the focused day
                  });
                  print('Selected day: $selectedDay');
                },
                headerVisible: false, // Hide the default header
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: AppColors.concolor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color(0xBB934047),
                    shape: BoxShape.circle,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      color: Colors.grey), // Change weekday color to grey
                  weekendStyle: TextStyle(
                      color: Colors.grey), // Change weekend color to grey
                ),
              ),
            ),
            SizedBox(height: 16),
            // Summary of events, holidays, or leaves
            _buildSummary(),
          ],
        ),
      ),
    );
  }

  // Custom header widget
  Widget _buildCustomHeader() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Space between the two sides
      children: [
        // Month and Year on the left
        Text(
          DateFormat('MMMM yyyy')
              .format(_focusedDay), // Format to show full month name and year
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Chevron icons on the right
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: AppColors.concolor),
              onPressed: () {
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month - 1);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: AppColors.concolor),
              onPressed: () {
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month + 1);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  // Widget to build a single rectangle for indicators
  Widget _buildIndicators() {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Color(0xFFD28F91),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _indicator(AppColors.concolor, 'Events'),
          _indicator(AppColors.concolor, 'Holidays'),
          _indicator(AppColors.concolor, 'Leave'),
        ],
      ),
    );
  }

  // Helper function to create an indicator
  Widget _indicator(Color color, String label) {
    bool isSelected = _currentView.toLowerCase() == label.toLowerCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentView = label.toLowerCase();
        });
      },
      child: Container(
        height: 5,
        width: 108,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    switch (_currentView) {
      case 'holidays':
        return _buildSummaryBox(
          title: 'App design',
          description:
              'Celebrate the National Day and Labor Day with various activities and events planned throughout the country.',
          priority: 'Medium',
          date: '1st January', // Default date for holidays
          location: 'National Park',
            cornerText:'Task'// Default location for holidays
        );

      case 'leave':
        return _buildSummaryBox(
          title: 'App design',
          description:
              'Sick Leave on 3rd March. Ensure to inform your team and manage your tasks accordingly.',
          priority: 'Low',
          date: '3rd March', // Default date for leave
          location: 'N/A',
            cornerText:'Task'// No specific location for leave
        );

      case 'events':
      default:
        return _buildSummaryBox(
          title: 'App design',
          description:
              'Meeting with the team at 10 AM to discuss project updates and deadlines.',
          priority: 'High',
          date: '25th', // Default date for events
          location: 'Conference Room A efault location for holidays',
            cornerText:'Task'// Default location for events
        );
    }
  }

  Widget _buildSummaryBox({
    required String title,
    required String description,
    String? priority,
    required String date,
    required String location,
    required String cornerText, // New parameter for the corner text
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left-side vertical bar
        Container(
          width: 10,
          height: 120,
          decoration: BoxDecoration(
            color: getPriorityColor(priority ?? 'Medium'),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        SizedBox(width: 0),
        Expanded(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              if (priority != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: getPriorityColor(priority),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      priority,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            description,
                            style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: AppColors.concolor),
                              SizedBox(width: 4),
                              Text(
                                'Date: $date',
                                style: GoogleFonts.montserrat(fontSize: 10, color: Colors.black),
                              ),
                              SizedBox(width: 16),
                              Icon(Icons.location_on, size: 16, color: AppColors.concolor),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Location: $location',
                                  style: GoogleFonts.montserrat(fontSize: 10, color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.concolor),
                  ],
                ),
              ),
              // Positioned text box in the top-right corner
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    cornerText,
                    style: GoogleFonts.montserrat(fontSize: 10, color: AppColors.concolor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _clickableTitle(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentView = title.toLowerCase();
        });
      },
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _currentView.toLowerCase() == title.toLowerCase()
              ? AppColors.concolor
              : Colors.black,
        ),
      ),
    );
  }
}
