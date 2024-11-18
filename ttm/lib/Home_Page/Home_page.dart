import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure to import Google Fonts
import 'package:ttm/Comman_pages/Constant.dart';
import '../Event_Detail_Pages/Event_Detail.dart';
import '../Comman_pages/Widgets_page.dart';
import 'Home_page_Widgets.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String buttonText = "Check In";
  String _selectedButton = 'Today';
  HomePageData _homePageData = getDefaultHomePageData(); // Initial data
  String greetingMessage = '';

  @override
  void initState() {
    super.initState();
    _setGreetingMessage();
  }

  void _toggleCheckInOut() {
    setState(() {
      buttonText = (buttonText == "Check In") ? "Check Out" : "Check In";
    });

    print("$buttonText button pressed");
  }

  Future<void> _refreshData() async {
    // Simulate a network request or data fetch
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Refresh the data by re-fetching it
      _homePageData = getDefaultHomePageData(); // Fetching default data again
    });
    print("Data refreshed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.concolor, // Change the color of the refresh indicator
        backgroundColor: Colors.white,
        onRefresh: _refreshData, // Call the refresh method
        child: SingleChildScrollView(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0), // Set vertical padding
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
                          PopupMenuTheme(
                            data: PopupMenuThemeData(
                              color: Colors
                                  .white, // Set the background color to white
                            ),
                            child: PopupMenuButton<String>(
                              icon: Icon(Icons.account_circle,
                                  size: 40, color: AppColors.concolor),
                              onSelected: (value) =>
                                  onMenuItemSelected(value, context),
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem<String>(
                                  value: 'profile',
                                  child: Row(
                                    children: [
                                      Icon(Icons.person,
                                          color: AppColors.concolor),
                                      SizedBox(width: 8),
                                      Text('Profile',
                                          style: GoogleFonts.montserrat()),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'notification',
                                  child: Row(
                                    children: [
                                      Icon(Icons.notifications,
                                          color: AppColors.concolor),
                                      SizedBox(width: 8),
                                      Text('Notifications',
                                          style: GoogleFonts.montserrat()),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'help',
                                  child: Row(
                                    children: [
                                      Icon(Icons.help,
                                          color: AppColors.concolor),
                                      SizedBox(width: 8),
                                      Text('Help',
                                          style: GoogleFonts.montserrat()),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'logout',
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout,
                                          color: AppColors.concolor),
                                      SizedBox(width: 8),
                                      Text('Logout',
                                          style: GoogleFonts.montserrat()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Transform.translate(
                        offset: const Offset(0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greetingMessage,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF505050),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Let’s get to work!",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
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
                            const SizedBox(height: 16),
                            // Search Box
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
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
                                      color: Colors.grey.withOpacity(0.2),
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
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search,
                                          color: AppColors.concolor),
                                      hintText: 'Search',
                                      hintStyle: GoogleFonts.montserrat(
                                          color: Colors.grey),
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

              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEAEAEA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.only(
                            left: 8.0,
                            right:
                                8.0), // Optional padding for background container
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 190,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // Filter tasks by status
                                  itemCount: _homePageData.tasks
                                      .where((task) =>
                                          task.status == 'Not Started' ||
                                          task.status == 'In Progress' ||
                                              task.status == 'Overdue')
                                      .length,
                                  itemBuilder: (context, index) {
                                    // Get the filtered tasks
                                    final filteredTasks = _homePageData.tasks
                                        .where((task) =>
                                            task.status == 'Not Started' ||
                                            task.status == 'In Progress' ||
                                                task.status == 'Overdue')
                                        .toList();
                                    final task = filteredTasks[index];

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right:
                                              10.0), // Adds spacing between boxes
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EventDetailPage(
                                                title: task.title,
                                                description: task.description,
                                                priority: task.priority,
                                                status: task.status,
                                                date: task.date,
                                                location: task.location,
                                                pdfUrls: task.pdfUrls ?? [],
                                                Event: task.Event,
                                                Assignedby: task.Assignedby,
                                                Attachmentpdfurl:
                                                    task.Attachmentpdfurl,
                                                fromDate: task.date,
                                                toDate: task.date,
                                                fromTime:
                                                    "", // Set actual fromTime if available
                                                toTime:
                                                    "", // Set actual toTime if available
                                              ),
                                            ),
                                          );
                                        },
                                        child: buildTaskDetailBox(
                                          task.title,
                                          task.description,
                                          Colors.white,
                                          task.priority,
                                          task.status,
                                          task.date,
                                          task.location,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      AppWidgets.divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: buildTaskBox('Not Started', Colors.grey,
                                  double.infinity, 90, 5, Icons.pending),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: buildTaskBox('In Progress', Colors.orange,
                                  double.infinity, 90, 10, Icons.rotate_left),
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
                              child: buildTaskBox('Completed', Colors.green,
                                  double.infinity, 90, 10, Icons.check_circle),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: buildTaskBox('Overdue', Color(0xFFC52D28),
                                  double.infinity, 90, 5, Icons.timer),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 10.0),
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
                              'You have ${_homePageData.meetings.length} Meetings Today',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 1),
                            // Wrap the Column in a SingleChildScrollView if needed
                            SingleChildScrollView(
                              child: Column(
                                children: _homePageData.meetings.map((meeting) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EventDetailPage(
                                            title: meeting.title,
                                            description: meeting.description,
                                            priority: meeting.priority,
                                            status: meeting.status,
                                            date: meeting
                                                .fromDate, // You can choose to send fromDate or toDate
                                            location: meeting.location,
                                            pdfUrls: meeting.pdfUrls,
                                            Event: meeting.Event,
                                            Assignedby: meeting.Assignedby,
                                            Attachmentpdfurl:
                                                meeting.Attachmentpdfurl,
                                            fromDate: meeting.fromDate,
                                            toDate: meeting.toDate,
                                            fromTime: meeting.fromTime,
                                            toTime: meeting.toTime,
                                          ),
                                        ),
                                      );
                                    },
                                    child: buildMeetingDetailBox(
                                      meeting.title,
                                      meeting.description,
                                      Colors.white,
                                      meeting.priority,
                                      meeting.status,
                                      meeting.fromDate,
                                      meeting.toDate,
                                      meeting.fromTime,
                                      meeting.toTime,
                                      meeting.location,
                                    ),
                                  );
                                }).toList(),
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
      ),
    );
  }

  void _setGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      greetingMessage = 'Good Morning, John Harry M';
    } else if (hour < 18) {
      greetingMessage = 'Good Afternoon, John Harry M';
    } else {
      greetingMessage = 'Good Evening, John Harry M';
    }
  }
}
