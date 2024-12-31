import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart'; // Import the table_calendar package
import 'package:ttm/Comman_pages/Constant.dart';
import '../Comman_pages/Widgets_page.dart';
import '../Event_Create_pages/Task_Page.dart';
import '../Event_Detail_Pages/Event_Detail.dart';
import '../Leave_Apply_pages/Leave_Apply_page.dart';
import '../Comman_pages/Navigation_page.dart';
import 'Callender_Service.dart';
import 'model.dart';
import 'package:http/http.dart' as http;

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarEventData? _calendarEventData;
  String _currentView = 'events'; // Default view is events
  DateTime _focusedDay = DateTime.now(); // Track the focused day
  DateTime? _startDate; // Variable for the start date
  DateTime? _endDate; // Variable for the end date
  DateTime? _selectedDate; // Variable for the selected date
  List<TaskCalender> tasks = []; // Replace with your actual data source
  List<MeetingCalender> meetings = []; // Replace with your actual data source
  List<DateTime> _selectedDates = []; // List to hold selected dates
  bool _isLoading = false; // Add this line
  List<Leave> _leaveStatuses = []; // Variable to hold the fetched leave statuses
  String? _holidayDetail; // Variable to hold the selected holiday detail
  final String userId = AppConstants.userId ?? '';
  Map<DateTime, String> _holidays = {};
  Map<DateTime, Leave> _leaveDetails = {};
  String? _leaveDetail;
  final CalendarService _calendarService = CalendarService();
  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();

    _focusedDay = DateTime.now();
    _selectedDate = DateTime.now();
    _focusedDay = DateTime.now();
    _selectedDate = DateTime.now();
    _startDate = null; // Reset start date
    _endDate = null; // Reset end date
    _holidayDetail = null; // Reset holiday detail
    _fetchInitialCalendarData();
  }
  Future<void> _fetchCalendarData(List<DateTime> selectedDates) async {
    setState(() {
      _isLoading = true; // Start loading
    });

    // Clear previous data
    _calendarEventData = null;

    for (DateTime date in selectedDates) {
      // Fetch calendar data for each selected date
      CalendarEventData? data = await _calendarService.fetchCalendarData(userId, date);
      if (data != null) {
        // Merge data if needed
        if (_calendarEventData == null) {
          _calendarEventData = data;
        } else {
          _calendarEventData!.tasks.addAll(data.tasks);
          _calendarEventData!.meetings.addAll(data.meetings);
        }
      }
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
  }
  Future<void> _fetchInitialCalendarData() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    // Fetch data for today's date
    _calendarEventData = await _calendarService.fetchCalendarData(userId, DateTime.now());

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  Future<void> _fetchLeaveData(DateTime selectedDay) async {
    try {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Fetch leave data for the user
      final List<Leave> leaves = await _calendarService.fetchLeaveData(userId);

      // Populate _leaveDetails with all leave dates
      _leaveDetails = {};
      for (var leave in leaves) {
        DateTime fromDate = normalizeDate(leave.fromDate);
        DateTime toDate = normalizeDate(leave.toDate);
        for (DateTime date = fromDate; date.isBefore(toDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
          _leaveDetails[date] = leave; // Store the leave details for each date in the range
        }
      }

      // Update the selected date and focused day
      _selectedDate = normalizeDate(selectedDay); // Normalize selected date
      _focusedDay = selectedDay; // Update focused day to the selected day

      // Check if leave exists for the selected date
      Leave? leaveDetails = _leaveDetails[_selectedDate];
      if (leaveDetails != null) {
        print('Leave Details: ${leaveDetails.reason}');
        _leaveDetail = leaveDetails.reason; // Update leave detail if it exists
      } else {
        print('No leave details found for this date.');
        _leaveDetail = null; // Reset leave detail if none exists
      }
    } catch (e) {
      print('Error fetching leave data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load leave data.')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  Future<void> _fetchHolidayData() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    _holidays = await _calendarService.fetchHolidayData();

    setState(() {
      _isLoading = false; // Stop loading
    });
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
        actions: [
          // Show the plus button only when the current view is 'leave'
          if (_currentView == 'leave')
            IconButton(
              icon: Icon(Icons.add_circle_outline_rounded,
                  color: AppColors.backwhite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeaveApplyPage()),
                );
              },
            ),
          if (_currentView == 'events')
            IconButton(
              icon: Icon(Icons.add_circle_outline_rounded,
                  color: AppColors.backwhite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Createevent()),
                );
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCalendar, // Attach the refresh function
        color: AppColors.concolor,
        child: SingleChildScrollView(
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
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => _selectedDate != null && _selectedDate!.isSameDay(day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                        _selectedDate = normalizeDate(selectedDay); // Normalize selected date

                        // Check if the selected date corresponds to any holiday
                        DateTime selectedDateAtMidnight = normalizeDate(selectedDay);
                        if (_holidays.containsKey(selectedDateAtMidnight)) {
                          _holidayDetail = _holidays[selectedDateAtMidnight]; // Get the holiday name
                        } else {
                          _holidayDetail = null; // Reset if no holiday
                        }
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay; // Update the focused day when swiping
                      });
                    },
                    headerVisible: false,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    calendarFormat: CalendarFormat.month,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      holidayDecoration: BoxDecoration(
                        color: Colors.pink[100], // Light pink color for holidays
                        shape: BoxShape.circle,
                      ),
                      holidayTextStyle: TextStyle(
                        color: Colors.black, // Text color for holidays
                      ),
                    ),
                    holidayPredicate: (day) {
                      return _holidays.containsKey(normalizeDate(day)); // Check if the day is a holiday
                    },
                  ):
                  _currentView == 'events'
                      ? TableCalendar(
                    focusedDay: _focusedDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      if (_isLoading) return; // Prevent selection if loading

                      setState(() {
                        _focusedDay = focusedDay;

                        if (_selectedDates.contains(selectedDay)) {
                          _selectedDates.remove(selectedDay);
                        } else {
                          _selectedDates.add(selectedDay);
                        }

                        // Clear previous data
                        _calendarEventData = null;
                        _startDate = null;
                        _endDate = null;
                        _holidayDetail = null;
                      });

                      _fetchCalendarData(_selectedDates);
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    headerVisible: false,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    calendarFormat: CalendarFormat.month,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      // Optionally, you can change the decoration for disabled dates
                      disabledDecoration: BoxDecoration(
                        color: Colors.grey[300], // Light grey for disabled dates
                        shape: BoxShape.circle,
                      ),
                    ),
                    selectedDayPredicate: (day) {
                      return _selectedDates.contains(day);
                    },
                  )
                  :_currentView == 'leave'
                      ? TableCalendar(
                      focusedDay: _focusedDay,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                          _selectedDate = normalizeDate(selectedDay); // Normalize selected date
                        });

                        Leave? leaveDetails = _leaveDetails[_selectedDate];
                        if (leaveDetails != null) {
                          print('Leave Details: ${leaveDetails.reason}');
                          setState(() {
                            _leaveDetail = leaveDetails.reason; // Update holiday detail
                          });
                        } else {
                          print('No leave details found for this date.');
                          setState(() {
                            _leaveDetail = null; // Reset holiday detail
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                      },
                      headerVisible: false,
                      firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  calendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    holidayDecoration: BoxDecoration(
                      color: Colors.pink[100], // Light pink color for leave dates
                      shape: BoxShape.circle,
                    ),
                    holidayTextStyle: TextStyle(
                      color: Colors.black, // Text color for holidays
                    ),
                  ),
                    holidayPredicate: (day) {
                      // Normalize the day for comparison
                      DateTime normalizedDay = normalizeDate(day);

                      // Check if the day falls within any leave date range
                      return _leaveDetails.values.any((leave) {
                        DateTime leaveStart = normalizeDate(leave.fromDate);
                        DateTime leaveEnd = normalizeDate(leave.toDate);

                        // Check if the normalized day is between the leave start and end dates (inclusive)
                        return normalizedDay.isAfter(leaveStart) && normalizedDay.isBefore(leaveEnd) ||
                            normalizedDay.isAtSameMomentAs(leaveStart) ||
                            normalizedDay.isAtSameMomentAs(leaveEnd);
                      });
                    },
                  selectedDayPredicate: (day) => _selectedDate != null && _selectedDate!.isSameDay(day),
                )

                      : Container(),


                ),
                SizedBox(height: 16),
                if (_isLoading) // Check if loading
                  _buildShimmerLoading()
                // Check if calendar event data is null
                else if (_calendarEventData == null && _currentView == 'events')
                  Center(
                    child: Text(
                      'No events found for this date.',
                      style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey),
                    ),
                  )
                else if (_currentView != 'holidays' && _currentView != 'leave') ...[
                    if (_selectedDate != null && _endDate == null)
                      _buildSummary(
                          _calendarEventData!.tasks, _calendarEventData!.meetings)
                    else if (_startDate != null && _endDate != null)
                      _buildSummary(
                          tasks, meetings) // Provide filtered task/meeting lists
                    else
                      _buildSummary(
                          tasks, meetings), // Provide default task/meeting lists
                  ],

                // If _currentView is 'holidays' and _selectedDate is not null, show holiday details
                if (_currentView == 'holidays' && _selectedDate != null)
                  _buildHolidayDetail(),

                // If _currentView is 'leave' and _selectedDate is not null, show leave details
                if (_currentView == 'leave' && _selectedDate != null)
                  _buildLeaveDetail(),
                // Provide default task/meeting lists
              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget _buildLeaveDetail() {
    // Ensure _selectedDate is not null
    if (_selectedDate == null) return Container();

    Leave? leaveStatus = _leaveDetails[_selectedDate];

    // Extract day, month, year for UI
    String day = DateFormat('d').format(_selectedDate!);
    String month = DateFormat('MMMM').format(_selectedDate!);
    String year = DateFormat('y').format(_selectedDate!);

    // Define status and title variables
    String status = leaveStatus?.groupId ?? 'No Leave';
    String leaveTypeId = leaveStatus?.leaveType ?? ''; // Changed from title to leaveTypeId
    String reason = leaveStatus?.reason ?? ''; // Changed from description to reason
    DateTime fromDate = leaveStatus?.fromDate ?? DateTime.now();
    DateTime toDate = leaveStatus?.toDate ?? DateTime.now();

    final Map<String, Color> statuses = {
      'Approved': Colors.green,
      'Rejected': Colors.red,
      'Waiting': Colors.orange,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the date
        Row(
          children: [
            SizedBox(
              height: 70,
              child: Text(
                day,
                style: GoogleFonts.montserrat(
                    fontSize: 50, fontWeight: FontWeight.bold),
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

        // Display the status indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: statuses.keys.map((s) {
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                          color: statuses[s]!, shape: BoxShape.circle),
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
        Stack(
          children: [
            // Vertical status indicator with rounded corners
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 130,
                decoration: BoxDecoration(
                  color: statuses[status] ?? Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
            ),
            // Main container for leave details
            Container(
              height: 120,
              margin: EdgeInsets.only(left: 10), // Add margin to avoid overlap with the vertical line
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
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // If there is a leave status, display the leave type and dates
                    if (leaveStatus != null) ...[
                      Text(
                        '$leaveTypeId', // Display leaveTypeId instead of title
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                        maxLines: 1, // Limit to a single line
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            'From: ${DateFormat('MMMM d, y').format(fromDate)}',
                            style: GoogleFonts.montserrat(
                                fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            'To: ${DateFormat('MMMM d, y').format(toDate)}',
                            style: GoogleFonts.montserrat(
                                fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        '$reason', // Display reason instead of description
                        style: GoogleFonts.montserrat(
                            fontSize: 10, color: Colors.black45),
                      ),
                    ] else ...[
                      // If there is no leave status, display a "No Leaves" message
                      Container(
                        width: double.infinity, // Full width
                        height: 100, // Specific height
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black54, width: 1),
                        ),
                        padding: EdgeInsets.all(20), // Padding for spacing
                        child: Center(
                          child: Text(
                            'No Leaves',
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Status badge positioned at the top right corner
            if (leaveStatus != null)
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
                    style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
    String month = DateFormat('MMMM').format(_selectedDate!); // Get the full month name
    String year = DateFormat('yyyy').format(_selectedDate!); // Get the year

    // Check if the selected date is a holiday
    String holidayDetail = _holidayDetail ?? 'No holiday on this date.'; // Get holiday detail or default message

    return Container(
      padding: EdgeInsets.all(10), // Add padding for better spacing
      margin: EdgeInsets.only(top: 10), // Margin for spacing from other widgets
      decoration: BoxDecoration(
        color: Color(0xFFD6D6D6), // Light grey background for the holiday box
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF7E1416), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
        children: [
          // Row for day and month/year
          Row(
            children: [
              // Day
              Text(
                day, // Show the day
                style: GoogleFonts.montserrat(
                  fontSize: 50, // Size for the day
                  fontWeight: FontWeight.bold, // Make the day bold
                ),
              ),
              // Directly display month and year without SizedBox
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align month and year to the left
                children: [
                  Text(
                    month, // Show the month
                    style: GoogleFonts.montserrat(
                      fontSize: 16, // Size for the month
                      fontWeight: FontWeight.normal, // Normal weight for month
                    ),
                  ),
                  Text(
                    year, // Show the year
                    style: GoogleFonts.montserrat(
                      fontSize: 16, // Size for the year
                      fontWeight: FontWeight.normal, // Normal weight for year
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Show the holiday detail without any spacing
          Text(
            holidayDetail, // Show the holiday detail
            style: GoogleFonts.montserrat(fontSize: 16),
            textAlign: TextAlign.left, // Ensure text is aligned to the left
          ),
        ],
      ),
    );
  }

  Widget _buildTaskAndMeetingStatusSummary() {
    // Get the combined counts
    Map<String, int> counts = _getCombinedCounts();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: counts.keys.map((status) {
        Color dotColor;
        Color backgroundColor; // Variable for background color
        switch (status) {
          case 'Not Started':
            dotColor = Colors.grey;
            backgroundColor =
                Colors.grey[200]!; // Light grey background for Not Started
            break;
          case 'In Progress':
            dotColor = Colors.orange;
            backgroundColor =
                Colors.grey[200]!; // Light orange background for In Progress
            break;
          case 'Completed':
            dotColor = Colors.green;
            backgroundColor =
                Colors.grey[200]!; // Light green background for Completed
            break;
          case 'Overdue':
            dotColor = Colors.red;
            backgroundColor =
                Colors.grey[200]!; // Light red background for Overdue
            break;
          default:
            dotColor = Colors.red;
            backgroundColor =
                Colors.grey[200]!; // Light red background for default
        }

        return Container(
          decoration: BoxDecoration(
            color: backgroundColor, // Set the background color for each status
            borderRadius: BorderRadius.circular(8.0), // Set the border radius
          ),
          padding: EdgeInsets.symmetric(
              horizontal: 3.0, vertical: 4.0), // Add padding for better spacing
          margin:
              EdgeInsets.symmetric(horizontal: 1.0), // Add margin between items
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the dot and text vertically
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
                '$status (${counts[status]})', // Display the combined count
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

  Widget _buildSummary(List<TaskCalender> tasks, List<MeetingCalender> meetings) {
    // Create a list to hold all event widgets
    List<Widget> eventWidgets = [];

    // Check if there are any tasks or meetings
    if (tasks.isEmpty && meetings.isEmpty) {
      return Center(
        child: Text(
          'No events found for this date.',
          style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Add Task widgets based on the filtering condition
    eventWidgets.addAll(tasks.map((task) {
      return GestureDetector(
        onTap: () {
          // Navigate to the EventDetailPage when the task box is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailPage(
                title: task.eventName,
                description: task.description,
                priority: task.priority,
                status: task.statusName,
                date: task.dueDate,
                location: task.location,
                pdfUrls: task.pdfUrls ?? [],
                Event: task.eventType,
                Assignedby: task.isSelfEvent ? "" : "HQ",
                Attachmentpdfurl: task.attachmentPdfUrls,
                fromDate: task.dueDate,
                toDate: task.dueDate,
                fromTime: "",
                toTime: "",
              ),
            ),
          );
        },
        child: Column(
          children: [
            buildTaskDetailBox(
              title: task.eventName,
              description: task.description,
              priority: task.priority,
              date: task.dueDate, // Format date
              location: task.location,
              event: task.eventType,
              assignedBy: task.isSelfEvent ? "" : "HQ",
            ),
            SizedBox(height: 16), // Space between boxes
          ],
        ),
      );
    }));

    // Add Meeting widgets based on the filtering condition
    eventWidgets.addAll(meetings.map((meeting) {
      return GestureDetector(
        onTap: () {
          // Navigate to the EventDetailPage when the meeting box is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailPage(
                title: meeting.eventName,
                description: meeting.description,
                priority: meeting.priority,
                status: meeting.statusName,
                date: meeting.startDate,
                location: meeting.venue,
                pdfUrls: meeting.pdfUrls ?? [],
                Event: meeting.eventType,
                Assignedby: meeting.isSelfEvent ? "" : "HQ",
                Attachmentpdfurl: meeting.attachmentPdfUrls,
                fromDate: meeting.startDate,
                toDate: meeting.endDate,
                fromTime: meeting.fromTime,
                toTime: meeting.toTime,
              ),
            ),
          );
        },
        child: Column(
          children: [
            buildMeetingDetailBox(
              title: meeting.eventName,
              description: meeting.description,
              priority: meeting.priority,
              status: meeting.statusName,
              fromDate: meeting.startDate,
              toDate: meeting.endDate,
              fromTime: meeting.fromTime,
              toTime: meeting.toTime,
              event: meeting.eventType,
              assignedby: meeting.isSelfEvent ? "" : "HQ",
              location: meeting.venue,
            ),
            SizedBox(height: 16), // Space between boxes
          ],
        ),
      );
    }));

    // Return the complete column with all events
    return Column(
      children: eventWidgets,
    );
  }

  Widget _Eventbox({
    required String title,
    required String description,
    String? priority,
    required String date,
    required String location,
    required String cornerText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
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
                              Expanded(
                                child: Text(
                                  title,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (priority != null) ...[
                                SizedBox(
                                    width:
                                        30), // Add space between title and priority
                                Transform.translate(
                                  offset: Offset(
                                      -20, 0), // Move 20 pixels to the left
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: getPriorityColor(priority),
                                      borderRadius: BorderRadius.circular(2),
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
                                '$date',
                                style: GoogleFonts.montserrat(
                                    fontSize: 10, color: Colors.black),
                              ),
                              SizedBox(width: 16),
                              Icon(Icons.location_on,
                                  size: 16, color: AppColors.concolor),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '$location',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 10, color: Colors.black),
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
                top: 1,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "[$cornerText]",
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
  void _fetchHolidayDetailsForDate(DateTime date) {
    DateTime normalizedDate = normalizeDate(date);
    if (_holidays.containsKey(normalizedDate)) {
      _holidayDetail = _holidays[normalizedDate]; // Get the holiday name
    } else {
      _holidayDetail = null; // Reset if no holiday
    }
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
        if (_currentView == 'holidays') {
          _fetchHolidayData(); // Fetch leave data for today when switching to leave view
          _fetchHolidayDetailsForDate(DateTime.now());
        }
        if (_currentView == 'leave') {
          _fetchLeaveData(DateTime.now()); // Fetch leave data for today when switching to leave view
        }
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


  Widget _buildShimmerLoading() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100, // Adjust height as needed
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100, // Adjust height as needed
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100, // Adjust height as needed
            color: Colors.white,
          ),
        ),
      ],
    );
  }
  Map<String, int> _getCombinedCounts() {
    // Initialize a map to hold task and meeting counts
    Map<String, int> combinedCounts = {
      'Not Started': 0,
      'In Progress': 0,
      'Completed': 0,
      'Overdue': 0, // If you have an 'Overdue' status
    };

    // Check if _calendarEventData is not null
    if (_calendarEventData != null) {
      // Count tasks for each status
      for (var task in _calendarEventData!.tasks) {
        if (task.statusName == 'Not Started') {
          combinedCounts['Not Started'] = combinedCounts['Not Started']! + 1;
        } else if (task.statusName == 'In Progress') {
          combinedCounts['In Progress'] = combinedCounts['In Progress']! + 1;
        } else if (task.statusName == 'Completed') {
          combinedCounts['Completed'] = combinedCounts['Completed']! + 1;
        } else if (task.statusName == 'Overdue') {
          combinedCounts['Overdue'] = combinedCounts['Overdue']! + 1;
        }
      }

      // Count meetings for each status
      for (var meeting in _calendarEventData!.meetings) {
        if (meeting.statusName == 'Not Started') {
          combinedCounts['Not Started'] = combinedCounts['Not Started']! + 1;
        } else if (meeting.statusName == 'In Progress') {
          combinedCounts['In Progress'] = combinedCounts['In Progress']! + 1;
        } else if (meeting.statusName == 'Completed') {
          combinedCounts['Completed'] = combinedCounts['Completed']! + 1;
        } else if (meeting.statusName == 'Overdue') {
          combinedCounts['Overdue'] = combinedCounts['Overdue']! + 1;
        }
      }
    }

    return combinedCounts;
  }

  Future<void> _refreshCalendar() async {
    setState(() {
      _focusedDay = DateTime.now(); // Reset focused day to today
      _selectedDate = DateTime.now(); // Reset selected date to today
      _startDate = null; // Reset start date
      _endDate = null; // Reset end date
      _holidayDetail = null; // Reset holiday detail
    });
  }
}
extension DateTimeComparison on DateTime {
  bool isSameDay(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}