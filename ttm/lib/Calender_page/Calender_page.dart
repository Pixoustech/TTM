import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart'; // Import the table_calendar package
import 'package:ttm/Constant.dart';
import '../Home_Page/Home_page.dart';
import '../Home_Page/Home_page_Widgets.dart';
import '../Navigation_page.dart';
import '../Widgets_page.dart';
import 'model.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String _currentView = 'events'; // Default view is events
  DateTime _focusedDay = DateTime.now(); // Track the focused day
  DateTime? _startDate; // Variable for the start date
  DateTime? _endDate; // Variable for the end date
  DateTime? _selectedDate; // Variable for the selected date

  final List<LeaveStatus> _leaveStatuses = [
    LeaveStatus(fromDate: DateTime(2024, 10, 1), toDate: DateTime(2024, 10, 1), status: "Approved",title:"Design"),
    LeaveStatus(fromDate: DateTime(2024, 9, 15), toDate: DateTime(2024, 9, 16), status: "Rejected",title:"App develop"),
    LeaveStatus(fromDate: DateTime(2024, 12, 25), toDate: DateTime(2024, 12, 30), status: "Waiting",title:"App develop"), // Example with a range
  ];

  // Sample data for task statuses
  final Map<String, int> _taskStatuses = {
    'Not Started': 5,
    'In Progress': 3,
    'Completed': 10,
    'Overdue': 6,
  };


  // Sample holiday data
  final Map<DateTime, String> _holidays = {
    DateTime(2024, 10, 1): "Labor Day - A day to honor workers.",
    DateTime(2024, 9, 15): "National Day - Celebrate the nation's independence.",
    DateTime(2024, 12, 25): "Christmas - Celebrate with family and friends.",
    // Add more holidays as needed
  };

  String? _holidayDetail; // Variable to hold the selected holiday detail

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    // Set the focused day and selected date to today
    _focusedDay = DateTime.now();
    _selectedDate = DateTime.now();
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              _buildCustomHeader(),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: _currentView == 'holidays'
                    ? TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _selectedDate = selectedDay;

                      DateTime selectedDateAtMidnight = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                      if (_holidays.containsKey(selectedDateAtMidnight)) {
                        _holidayDetail = _holidays[selectedDateAtMidnight];
                      } else {
                        _holidayDetail = null;
                      }
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay; // Update the focused day when the user swipes
                    });
                  },
                  headerVisible: false,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: _selectedDate != null && _selectedDate == _focusedDay
                          ? const Color(0xBBB35258)
                          : AppColors.concolor,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: Color(0xFF910002),
                      shape: BoxShape.circle,
                    ),
                    holidayDecoration: BoxDecoration(
                      color: Color(0xFFFFF2F2), // Color for holidays
                      shape: BoxShape.circle,
                    ),
                    holidayTextStyle: TextStyle(
                      color: Colors.black, // Text color for holidays
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.grey),
                    weekendStyle: TextStyle(color: Colors.grey),
                  ),
                  selectedDayPredicate: (day) {
                    return _selectedDate != null && _selectedDate == day;
                  },
                  holidayPredicate: (day) {
                    return _holidays.containsKey(normalizeDate(day));
                  },
                )
                    :_currentView == 'events'? TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _selectedDate = selectedDay; // Set the selected date

                      // Check if the selected date is a holiday
                      if (_holidays.containsKey(selectedDay)) {
                        _holidayDetail = _holidays[selectedDay];
                      } else {
                        _holidayDetail = null; // Reset holiday detail if not a holiday
                      }
                      if (_startDate == null || (_endDate != null && _startDate != null)) {
                        _startDate = selectedDay; // Set start date
                        _endDate = null; // Reset end date
                      } else if (_startDate != null && selectedDay.isAfter(_startDate!)) {
                        _endDate = selectedDay; // Set end date if it's after start date
                      } else {
                        _startDate = selectedDay; // Reset start date
                        _endDate = null; // Reset end date
                      }
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay; // Update the focused day when the user swipes
                    });
                  },
                  headerVisible: false,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: _selectedDate != null && _selectedDate == _focusedDay
                          ? const Color(0xBBB35258) // Color for the selected date
                          : AppColors.concolor,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: Color(0xFF910002),
                      shape: BoxShape.circle,
                    ),
                    rangeStartDecoration: const BoxDecoration(
                      color: Colors.blue, // Color for the start date
                      shape: BoxShape.circle,
                    ),
                    rangeEndDecoration: const BoxDecoration(
                      color: Colors.red, // Color for the end date
                      shape: BoxShape.circle,
                    ),
                    rangeHighlightColor: AppColors.concolor,
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.grey),
                    weekendStyle: TextStyle(color: Colors.grey),
                  ),
                  selectedDayPredicate: (day) {
                    if (_startDate != null && _endDate != null) {
                      if (day.isAfter(_startDate!) && day.isBefore(_endDate!)) {
                        return true;
                      } else if (day == _startDate || day == _endDate) {
                        return true;
                      }
                    }
                    return _selectedDate != null && _selectedDate == day;
                  },
                )
                    : _currentView == 'leave' ? // In your TableCalendar widget for 'leave'
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _selectedDate = selectedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay; // Update the focused day when the user swipes
                    });
                  },
                  headerVisible: false,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: _selectedDate != null && _selectedDate == _focusedDay
                          ? const Color(0xBBB35258)
                          : AppColors.concolor,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: Color(0xFF910002),
                      shape: BoxShape.circle,
                    ),
                    holidayDecoration: BoxDecoration(
                      color: Color(0x94FFAEB1), // Set the background color for leave dates
                      shape: BoxShape.circle,
                    ),
                    holidayTextStyle: TextStyle(
                      color: Colors.white, // Text color for holidays
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.grey),
                    weekendStyle: TextStyle(color: Colors.grey),
                  ),
                  selectedDayPredicate: (day) {
                    return _selectedDate != null && _selectedDate == day;
                  },
                  holidayPredicate: (day) {
                    // Check if the date is within any leave range
                    return _leaveStatuses.any((leaveStatus) =>
                    day.isAfter(leaveStatus.fromDate.subtract(Duration(days: 1))) &&
                        day.isBefore(leaveStatus.toDate.add(Duration(days: 1))));
                  },
                ):
                Container(),
              ),
              SizedBox(height: 16),
              // Show task status summary only for Events
              if (_currentView == 'events')
                _buildTaskStatusSummary(),
              SizedBox(height: 16),
              // Show summary based on the current view
              if (_currentView != 'holidays' && _currentView != 'leave')
                _buildSummary(),

              if (_currentView == 'holidays' && _selectedDate != null)
                _buildHolidayDetail(),
              if (_currentView == 'leave' && _selectedDate != null)
                _buildLeaveDetail(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildLeaveDetail() {
    if (_selectedDate == null) return Container();

    LeaveStatus? leaveStatus = getLeaveStatusForDate(_selectedDate!);
    if (leaveStatus == null) {
      return Container();
    }

    // Extract day, month, year, and status for UI
    String day = DateFormat('d').format(_selectedDate!);
    String month = DateFormat('MMMM').format(_selectedDate!);
    String year = DateFormat('y').format(_selectedDate!);
    String status = leaveStatus.status;
    String title = leaveStatus.title;
    DateTime fromDate = leaveStatus.fromDate;
    DateTime toDate = leaveStatus.toDate;

    final Map<String, Color> statuses = {
      'Approved': Colors.green,
      'Rejected': Colors.red,
      'Waiting': Colors.orange,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: 50,
              child: Text(
                day,
                style: GoogleFonts.montserrat(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(month, style: GoogleFonts.montserrat(fontSize: 16)),
                Text(year, style: GoogleFonts.montserrat(fontSize: 16)),
              ],
            ),
          ],
        ),
        Divider(height: 20, thickness: 1, color: Colors.grey),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: statuses.keys.map((s) {
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(color: statuses[s]!, shape: BoxShape.circle),
                    ),
                    SizedBox(width: 4),
                    Text(s, style: GoogleFonts.montserrat(fontSize: 10)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16),
        // Outer container for the status box
        Row(
          children: [
            // Color bar on the left side, outside the main content
            Container(
              width: 10, // Adjust the width as needed
              height: 120, // Set the same height as the main content
              decoration: BoxDecoration(
                color: statuses[status] ?? Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
            SizedBox(width: 0), // Space between the bar and content
            // Main content section with dynamic size
            Expanded(
              child: Container(
                height: 120, // Set a default height
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack( // Use Stack to position the status badge
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10), // Adjusted padding for a more compact look
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$title [${leaveStatus.toDate.difference(leaveStatus.fromDate).inDays + 1} Days]',
                            style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.black),
                              SizedBox(width: 4),
                              Text(
                                'From: ${DateFormat('MMMM d, y').format(fromDate)}',
                                style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.black),
                              SizedBox(width: 4),
                              Text(
                                'To: ${DateFormat('MMMM d, y').format(toDate)}',
                                style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    // Status badge positioned at the top right corner
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statuses[status] ?? Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }




  Widget _buildHolidayDetail() {
    // Check if a date is selected
    if (_selectedDate == null) {
      return SizedBox.shrink(); // Return an empty widget if no date is selected
    }

    // Format the date components
    String day = DateFormat('dd').format(_selectedDate!); // Get the day
    String month =
    DateFormat('MMMM').format(_selectedDate!); // Get the full month name
    String year = DateFormat('yyyy').format(_selectedDate!); // Get the year

    // Check if the selected date is a holiday
    String holidayDetail = _holidayDetail ??
        'No holiday on this date.'; // Get holiday detail or default message

    return Container(
      padding: EdgeInsets.all(16), // Add padding for better spacing
      margin: EdgeInsets.only(top: 16), // Margin for spacing from other widgets
      decoration: BoxDecoration(
        color: Color(0xBBD6D6D6), // Light blue background for the holiday box
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF7E1416), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          // Row for day and month/year
          Row(
            children: [
              SizedBox(
                height: 110, // Height for the day
                child: Text(
                  day, // Show the day
                  style: GoogleFonts.montserrat(
                    fontSize: 50, // Size for the day
                    fontWeight: FontWeight.bold, // Make the day bold
                  ),
                ),
              ),
              SizedBox(width: 8), // Space between day and month/year
              Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align month and year to the left
                children: [
                  SizedBox(
                    height: 20, // Height for the month
                    child: Text(
                      month, // Show the month
                      style: GoogleFonts.montserrat(
                        fontSize: 16, // Size for the month
                        fontWeight:
                        FontWeight.normal, // Normal weight for month
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60, // Height for the year
                    child: Text(
                      year, // Show the year
                      style: GoogleFonts.montserrat(
                        fontSize: 16, // Size for the year
                        fontWeight: FontWeight.normal, // Normal weight for year
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 0), // Space between date and holiday detail
          Text(
            holidayDetail, // Show the holiday detail
            style: GoogleFonts.montserrat(fontSize: 16),
            textAlign: TextAlign.left, // Ensure text is aligned to the left
          ),
        ],
      ),
    );
  }



  // New widget to display task status summary
  Widget _buildTaskStatusSummary() {
    return Row(
      mainAxisAlignment : MainAxisAlignment.spaceEvenly,
      children: _taskStatuses.keys.map((status) {
        Color dotColor;
        Color backgroundColor; // Variable for background color
        switch (status) {
          case 'Not Started':
            dotColor = Colors.grey;
            backgroundColor = Colors.grey[200]!; // Light grey background for Not Started
            break;
          case 'In Progress':
            dotColor = Colors.orange;
            backgroundColor = Colors.grey[200] !; // Light orange background for In Progress
            break;
          case 'Completed':
            dotColor = Colors.green;
            backgroundColor = Colors.grey[200]!; // Light green background for Completed
            break;
          default:
            dotColor = Colors.red;
            backgroundColor = Colors.grey[200]!; // Light red background for default
        }

        return Container(
          decoration: BoxDecoration(
            color: backgroundColor, // Set the background color for each status
            borderRadius: BorderRadius.circular(8.0), // Set the border radius
          ),
          padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 4.0), // Add padding for better spacing
          margin: EdgeInsets.symmetric(horizontal: 1.0), // Add margin between items
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Center the dot and text vertically
            children: [
              Container(
                width: 5,
                height: 10,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1), // Add space between the dot and the text
              Text(
                '$status (${_taskStatuses[status]!})',
                style: GoogleFonts.montserrat(fontSize: 9),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Month and Year on the left
        Text(
          DateFormat('MMMM yyyy').format(_focusedDay), // Format to show full month name and year
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
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: AppColors.concolor),
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
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
          _focusedDay = DateTime.now(); // Reset focused day to today
          _selectedDate = DateTime.now(); // Reset selected date to today
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
        return Column(
          children: [
            _buildSummaryBox(
              title: 'National Day',
              description:
              'Celebrate the National Day with various activities and events planned throughout the country.',
              priority: 'Medium',
              date: '1st January', // Default date for holidays
              location: 'National Park',
              cornerText: 'Holiday', // Default location for holidays
            ),
            SizedBox(height: 16), // Add space between boxes
            _buildSummaryBox(
              title: 'Labor Day',
              description: 'Labor Day celebrations with parades and events.',
              priority: 'Medium',
              date: '1st May', // Additional date for holidays
              location: 'City Center',
              cornerText : 'Holiday', // Default location for holidays
            ),
          ],
        );

      case 'leave':
        return Column(
          children: [
            _buildSummaryBox(
              title: 'Sick Leave',
              description:
              'Sick Leave on 3rd March. Ensure to inform your team and manage your tasks accordingly.',
              priority: 'Low',
              date: '3rd March', // Default date for leave
              location: 'N/A',
              cornerText: 'Leave', // No specific location for leave
            ),
            SizedBox(height: 16), // Add space between boxes
            _buildSummaryBox(
              title: 'Vacation Leave',
              description: 'Vacation Leave from 10th to 20th March.',
              priority: 'Low',
              date: ' 10th - 20th March', // Additional date for leave
              location: 'N/A',
              cornerText: 'Leave', // No specific location for leave
            ),
          ],
        );

      case 'events':
      default:
        return Column(
          children: [
            _buildSummaryBox(
              title: 'Team Meeting',
              description:
              'Meeting with the team at 10 AM to discuss project updates and deadlines.',
              priority: 'Low',
              date: '25th', // Default date for events
              location: 'Conference Room A',
              cornerText: 'Task', // Default location for events
            ),
            SizedBox(height: 16), // Add space between boxes
            _buildSummaryBox(
              title: 'Project Deadline',
              description: 'Submit the final project report by the end ',
              priority: 'Low',
              date: '30th', // Additional date for events
              location: 'N/A',
              cornerText: 'Meeting', // Additional corner text for the new event
            ),
          ],
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
          width: 10 ,
          height: 130,
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
                height: 130,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
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
                            style: GoogleFonts.montserrat(
                                fontSize: 12, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 16, color: AppColors.concolor),
                              SizedBox(width: 4),
                              Text(
                                'Date: $date',
                                style: GoogleFonts.montserrat(
                                    fontSize: 10, color: Colors.black),
                              ),
                              SizedBox(width: 16),
                              Icon(Icons.location_on,
                                  size: 16, color: AppColors.concolor),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Location: $location',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 10 , color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: AppColors.concolor),
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
                    style: GoogleFonts.montserrat(
                        fontSize: 10, color: AppColors.concolor),
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
          _currentView = title.toLowerCase(); // Update the current view
          _focusedDay = DateTime.now(); // Reset focused day to today
          _selectedDate = DateTime.now(); // Reset selected date to today
          _startDate = null; // Reset start date
          _endDate = null; // Reset end date
          _holidayDetail = null; // Reset holiday detail
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

  LeaveStatus? getLeaveStatusForDate(DateTime selectedDate) {
    for (var leaveStatus in _leaveStatuses) {
      if (selectedDate.isAfter(leaveStatus.fromDate.subtract(Duration(days: 1))) &&
          selectedDate.isBefore(leaveStatus.toDate.add(Duration(days: 1)))) {
        return leaveStatus; // Return the leave data if the date is within range
      }
    }
    return null; // Return null if there's no leave on the selected date
  }


}