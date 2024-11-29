import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart'; // Import the table_calendar package
import 'package:ttm/Comman_pages/Constant.dart';
import '../Event_Create_pages/Task_Page.dart';
import '../Event_Detail_Pages/Event_Detail.dart';
import '../Home_Page/Home_page_Widgets.dart';
import '../Home_Page/model.dart';
import '../Leave_Apply_pages/Leave_Apply_page.dart';
import '../Comman_pages/Navigation_page.dart';
import 'model.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final homePageData = getDefaultHomePageData();

  String _currentView = 'events'; // Default view is events
  DateTime _focusedDay = DateTime.now(); // Track the focused day
  DateTime? _startDate; // Variable for the start date
  DateTime? _endDate; // Variable for the end date
  DateTime? _selectedDate; // Variable for the selected date

  final List<LeaveStatus> _leaveStatuses = getSampleLeaveStatuses();
  final Map<DateTime, String> _holidays = getSampleHolidays();

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
      body:RefreshIndicator(
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
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: CalendarFormat.month,
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _focusedDay = focusedDay;
                            _selectedDate = selectedDay;

                            DateTime selectedDateAtMidnight = DateTime(
                                selectedDay.year,
                                selectedDay.month,
                                selectedDay.day);
                            if (_holidays.containsKey(selectedDateAtMidnight)) {
                              _holidayDetail =
                                  _holidays[selectedDateAtMidnight];
                            } else {
                              _holidayDetail = null;
                            }
                          });
                        },
                        onPageChanged: (focusedDay) {
                          setState(() {
                            _focusedDay =
                                focusedDay; // Update the focused day when the user swipes
                          });
                        },
                        headerVisible: false,
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: _selectedDate != null &&
                                    _selectedDate == _focusedDay
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
                    : _currentView == 'events'
                        ? TableCalendar(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            calendarFormat: CalendarFormat.month,
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _focusedDay = focusedDay;
                                _selectedDate = selectedDay;

                                if (_startDate == null ||
                                    (_endDate != null && _startDate != null)) {
                                  _startDate = selectedDay; // Set start date
                                  _endDate = null; // Reset end date
                                } else if (_startDate != null &&
                                    selectedDay.isAfter(_startDate!)) {
                                  _endDate =
                                      selectedDay; // Set end date if it's after start date
                                } else {
                                  _startDate = selectedDay; // Reset start date
                                  _endDate = null; // Reset end date
                                }
                              });
                            },
                            onPageChanged: (focusedDay) {
                              setState(() {
                                _focusedDay =
                                    focusedDay; // Update the focused day when the user swipes
                              });
                            },
                            headerVisible: false,
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                color: _selectedDate != null &&
                                        _selectedDate == _focusedDay
                                    ? const Color(
                                        0xBBB35258) // Color for the selected date
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
                                if (day.isAfter(_startDate!) &&
                                    day.isBefore(_endDate!)) {
                                  return true;
                                } else if (day == _startDate ||
                                    day == _endDate) {
                                  return true;
                                }
                              }
                              return _selectedDate != null &&
                                  _selectedDate == day;
                            },
                          )
                        : _currentView == 'leave'
                            ? // In your TableCalendar widget for 'leave'
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
                                    _focusedDay =
                                        focusedDay; // Update the focused day when the user swipes
                                  });
                                },
                                headerVisible: false,
                                calendarStyle: CalendarStyle(
                                  selectedDecoration: BoxDecoration(
                                    color: _selectedDate != null &&
                                            _selectedDate == _focusedDay
                                        ? const Color(0xBBB35258)
                                        : AppColors.concolor,
                                    shape: BoxShape.circle,
                                  ),
                                  todayDecoration: const BoxDecoration(
                                    color: Color(0xFF910002),
                                    shape: BoxShape.circle,
                                  ),
                                  holidayDecoration: BoxDecoration(
                                    color: Color(
                                        0x94FFAEB1), // Set the background color for leave dates
                                    shape: BoxShape.circle,
                                  ),
                                  holidayTextStyle: TextStyle(
                                    color:
                                        Colors.white, // Text color for holidays
                                  ),
                                ),
                                daysOfWeekStyle: DaysOfWeekStyle(
                                  weekdayStyle: TextStyle(color: Colors.grey),
                                  weekendStyle: TextStyle(color: Colors.grey),
                                ),
                                selectedDayPredicate: (day) {
                                  return _selectedDate != null &&
                                      _selectedDate == day;
                                },
                                holidayPredicate: (day) {
                                  // Check if the date is within any leave range
                                  return _leaveStatuses.any((leaveStatus) =>
                                      day.isAfter(leaveStatus.fromDate
                                          .subtract(Duration(days: 1))) &&
                                      day.isBefore(leaveStatus.toDate
                                          .add(Duration(days: 1))));
                                },
                              )
                            : Container(),
              ),
              SizedBox(height: 16),

              if (_currentView == 'events') _buildTaskAndMeetingStatusSummary(),

        SizedBox(height: 16),

              if (_currentView != 'holidays' && _currentView != 'leave')
                if (_selectedDate != null && _endDate == null)
                  _buildSummary(singleDate: _selectedDate),
              // Call without parameters if needed
              if (_startDate != null && _endDate != null)
                _buildSummary(startDate: _startDate, endDate: _endDate)
              else
                _buildSummary(),

              if (_currentView == 'holidays' && _selectedDate != null)
                _buildHolidayDetail(),
              if (_currentView == 'leave' && _selectedDate != null)
                _buildLeaveDetail(),
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

    LeaveStatus? leaveStatus = getLeaveStatusForDate(_selectedDate!);

    // Extract day, month, year for UI
    String day = DateFormat('d').format(_selectedDate!);
    String month = DateFormat('MMMM').format(_selectedDate!);
    String year = DateFormat('y').format(_selectedDate!);

    // Define status and title variables
    String status = leaveStatus?.status ?? 'No Leave';
    String title = leaveStatus?.title ?? '';
    String description = leaveStatus?.description ?? '';
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
              margin: EdgeInsets.only(
                  left:
                      10), // Add margin to avoid overlap with the vertical line
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
                    // If there is a leave status, display the title and dates
                    if (leaveStatus != null) ...[
                      Text(
                        '$title [${leaveStatus.toDate.difference(leaveStatus.fromDate).inDays + 1} Days]',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        '$description ',
                        style: GoogleFonts.montserrat(
                            fontSize: 10, color: Colors.black45),
                      ),
                    ] else ...[
                      // If there is no leave status, display a "No Leaves" message
                      Container(
                        width: double
                            .infinity, // Make the container take the full width
                        height: 100, // Set a specific height for the container
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black54, width: 1),
                        ),
                        padding: EdgeInsets.all(
                            20), // Increase padding for more space around the text
                        child: Center(
                          // Center the text within the container
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
    String month =
        DateFormat('MMMM').format(_selectedDate!); // Get the full month name
    String year = DateFormat('yyyy').format(_selectedDate!); // Get the year

    // Check if the selected date is a holiday
    String holidayDetail = _holidayDetail ??
        'No holiday on this date.'; // Get holiday detail or default message

    return Container(
      padding: EdgeInsets.all(10), // Add padding for better spacing
      margin: EdgeInsets.only(top: 10), // Margin for spacing from other widgets
      decoration: BoxDecoration(
        color: Color(0xFFD6D6D6), // Light blue background for the holiday box
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF7E1416), width: 1),
      ),
      child: Column(
        // Change to Column to stack date and holiday detail
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align items to the start
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
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align month and year to the left
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
            backgroundColor = Colors.grey[200]!; // Light grey background for Not Started
            break;
          case 'In Progress':
            dotColor = Colors.orange;
            backgroundColor = Colors.grey[200]!; // Light orange background for In Progress
            break;
          case 'Completed':
            dotColor = Colors.green;
            backgroundColor = Colors.grey[200]!; // Light green background for Completed
            break;
          case 'Overdue':
            dotColor = Colors.red;
            backgroundColor = Colors.grey[200]!; // Light red background for Overdue
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

  Widget _buildSummary(
      {DateTime? singleDate, DateTime? startDate, DateTime? endDate})
  {
    // Retrieve the default home page data
    final homePageData = getDefaultHomePageData();

    // Create a list to hold all event widgets
    List<Widget> eventWidgets = [];

    String? formattedSingleDate =
    singleDate?.toLocal().toString().split(' ')[0];
    String? formattedStartDate = startDate?.toLocal().toString().split(' ')[0];
    String? formattedEndDate = endDate?.toLocal().toString().split(' ')[0];

    // Add Task widgets based on the filtering condition
    eventWidgets.addAll(homePageData.tasks.where((task) {
      DateTime taskDate = task.date.toLocal();

      // If singleDate is provided, filter by that date
      if (formattedSingleDate != null) {
        return taskDate.toString().split(' ')[0] == formattedSingleDate;
      }

      // If startDate and endDate are provided, filter by the date range
      if (startDate != null && endDate != null) {
        return taskDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            taskDate.isBefore(endDate.add(Duration(days: 1)));
      }

      // If no filtering condition is met, return false
      return false;
    }).map((task) {
      return GestureDetector(
        onTap: () {
          // Navigate to the EventDetailPage when the task box is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailPage(
                title: task.title,
                description: task.description,
                priority: task.priority,
                status: task.status,
                date: task.date,
                location: task.location,
                pdfUrls: task.pdfUrls ?? [],
                Event: task.Event,
                Assignedby: task.Assignedby,
                Attachmentpdfurl: task.Attachmentpdfurl,
                fromDate: task.date,
                toDate: task.date,
                fromTime: "",
                toTime: "",
              ),
            ),
          );
        },
        child: Column(
          children: [
            _Eventbox(
              title: task.title,
              description: task.description,
              priority: task.priority,
              date: task.date.toLocal().toString().split(' ')[0], // Format date
              location: task.location,
              cornerText: task.Event,
            ),
            SizedBox(height: 16), // Space between boxes
          ],
        ),
      );
    }));

    // Add Meeting widgets based on the filtering condition
    eventWidgets.addAll(homePageData.meetings.where((meeting) {
      DateTime meetingStartDate = meeting.fromDate.toLocal();

      // If singleDate is provided, filter by that date
      if (formattedSingleDate != null) {
        return meetingStartDate.toString().split(' ')[0] == formattedSingleDate;
      }

      // If startDate and endDate are provided, filter by the date range
      if (startDate != null && endDate != null) {
        return meetingStartDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            meetingStartDate.isBefore(endDate.add(Duration(days: 1)));
      }

      // If no filtering condition is met, return false
      return false;
    }).map((meeting) {
      return GestureDetector(
        onTap: () {
          // Navigate to the EventDetailPage when the meeting box is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailPage(
                title: meeting.title,
                description: meeting.description,
                priority: meeting.priority,
                status: meeting.status,
                date: meeting.fromDate,
                location: meeting.location,
                pdfUrls: meeting.pdfUrls ?? [],
                Event: meeting.Event,
                Assignedby: meeting.Assignedby,
                Attachmentpdfurl: meeting.Attachmentpdfurl,
                fromDate: meeting.fromDate,
                toDate: meeting.toDate,
                fromTime: meeting.fromTime,
                toTime: meeting.toTime,
              ),
            ),
          );
        },
        child: Column(
          children: [
            _Eventbox(
              title: meeting.title,
              description: meeting.description,
              priority: meeting.priority,
              date: '${meeting.fromDate.toLocal().toString().split(' ')[0]} - ${meeting.toDate.toLocal().toString().split(' ')[0]}', // Format date range
              location: meeting.location,
              cornerText: meeting.Event,
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
    // New parameter for the corner text

  })
  {
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
      if (selectedDate
              .isAfter(leaveStatus.fromDate.subtract(Duration(days: 1))) &&
          selectedDate.isBefore(leaveStatus.toDate.add(Duration(days: 1)))) {
        return leaveStatus; // Return the leave data if the date is within range
      }
    }
    return null; // Return null if there's no leave on the selected date
  }

  Map<String, int> _getCombinedCounts () {
    // Initialize a map to hold task and meeting counts
    Map<String, int> combinedCounts = {
      'Not Started': 0,
      'In Progress': 0,
      'Completed': 0,
      'Overdue': 0, // If you have an 'Overdue' status
    };

    // Count tasks for each status
    for (var task in homePageData.tasks) {
      if (task.status == 'Not Started') {
        combinedCounts['Not Started'] = combinedCounts['Not Started']! + 1;
      } else if (task.status == 'In Progress') {
        combinedCounts['In Progress'] = combinedCounts['In Progress']! + 1;
      } else if (task.status == 'Completed') {
        combinedCounts['Completed'] = combinedCounts['Completed']! + 1;
      } else if (task.status == 'Overdue') {
        combinedCounts['Overdue'] = combinedCounts['Overdue']! + 1;
      }
    }

    // Count meetings for each status
    for (var meeting in homePageData.meetings) {
      if (meeting.status == 'Not Started') {
        combinedCounts['Not Started'] = combinedCounts['Not Started']! + 1;
      } else if (meeting.status == 'In Progress') {
        combinedCounts['In Progress'] = combinedCounts['In Progress']! + 1;
      } else if (meeting.status == 'Completed') {
        combinedCounts['Completed'] = combinedCounts['Completed']! + 1;
      } else if (meeting.status == 'Overdue') {
        combinedCounts['Overdue'] = combinedCounts['Overdue']! + 1;
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
