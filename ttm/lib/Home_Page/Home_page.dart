import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  String _viewFilter = 'All';
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _setGreetingMessage();
  }

  void _toggleCheckInOut() {
    setState(() {
      buttonText = (buttonText == "Check In") ? "Check Out" : "Check In";
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      buttonText = "Check In"; // Reset button text
      _selectedButton = 'Today'; // Reset selected button
      searchQuery = ''; // Clear search query
      _searchController.clear(); // Clear the search box
      _homePageData = getUpdatedHomePageData(); // Fetching updated data
      _setGreetingMessage(); // Reset greeting message
    });
  }

  HomePageData getUpdatedHomePageData() {
    // Replace this with actual data fetching logic
    return getDefaultHomePageData(); // This is just a placeholder
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.concolor,
        backgroundColor: Colors.white,
        onRefresh: _refreshData,
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
                      horizontal: 10.0, vertical: 15.0),
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
                              color: Colors.white,
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
                            // Search Box
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              child: Column(
                                children: [
                                  Container(
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
                                        controller: _searchController,
                                        onChanged: _onSearchChanged,
                                        cursorColor: AppColors.concolor,
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
                                  // Display suggestions
                                  if (_suggestions.isNotEmpty)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _suggestions.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(_suggestions[index]),
                                            onTap: () {
                                              // Handle suggestion tap
                                              setState(() {
                                                searchQuery = _suggestions[index];
                                                _searchController.text = searchQuery;
                                                _suggestions.clear(); // Clear suggestions after selection
                                              });
                                            },
                                          );
                                        },
                                      ),
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
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAEAEA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _filterTasks().length +
                                      _filterMeetings().length,
                                  itemBuilder: (context, index) {
                                    if (index < _filterTasks().length) {
                                      final task = _filterTasks()[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
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
                                                  fromTime: "",
                                                  toTime: "",
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height:
                                                120, // Set a fixed height for the container
                                            child: buildTaskDetailBox(
                                              task.title,
                                              task.description,
                                              Colors.white,
                                              task.priority,
                                              task.status,
                                              task.date,
                                              task.location,
                                              task.Event,
                                              task.Assignedby
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      final meetingIndex =
                                          index - _filterTasks().length;
                                      final meeting =
                                          _filterMeetings()[meetingIndex];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EventDetailPage(
                                                  title: meeting.title,
                                                  description:
                                                      meeting.description,
                                                  priority: meeting.priority,
                                                  status: meeting.status,
                                                  date: meeting.fromDate,
                                                  location: meeting.location,
                                                  pdfUrls: meeting.pdfUrls,
                                                  Event: meeting.Event,
                                                  Assignedby:
                                                      meeting.Assignedby,
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
                                          child: Container(
                                            height:
                                                120, // Set a fixed height for the container
                                            child: buildTaskDetailBox(
                                              meeting.title,
                                              meeting.description,
                                              Colors.white,
                                              meeting.priority,
                                              meeting.status,
                                              meeting.fromDate,
                                              meeting.location,
                                              meeting.Event,
                                              meeting.Assignedby
                                            ),
                                          ),
                                        ),
                                      );
                                    }
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFilterButton('All'),
                            _buildFilterButton('Tasks'),
                            _buildFilterButton('Meetings'),
                          ],
                        ),
                      ),
                      if (_viewFilter == 'Tasks') ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tasks',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF505050),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'You have ${_filterTasks().length} Tasks Today',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_filterTasks().isEmpty)
                          Center(
                            child: Text(
                              'No Tasks Today',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: _filterTasks().map((task) {
                                  return GestureDetector(
                                    onTap: () {
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: buildTaskDetailBoxforhome(
                                        task.title,
                                        task.description,
                                        Colors.white,
                                        task.priority,
                                        task.status,
                                        task.date,
                                        task.location,
                                        task.Event,
                                        task.Assignedby,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],



                      if (_viewFilter == 'Meetings') ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft, // Align to the left
                                child: Text(
                                  'Meeting',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF505050),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft, // Align to the left
                                child: Text(
                                  'You have ${_filterMeetings().length} Meetings Today',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 1),
                              SingleChildScrollView(
                                child: Column(
                                  children: _filterMeetings().map((meeting) {
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
                                              date: meeting.fromDate,
                                              location: meeting.location,
                                              pdfUrls: meeting.pdfUrls,
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
                                        meeting.Assignedby,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      if (_viewFilter == 'All') ...[
                        // Tasks Section
                        if (_filterTasks().isNotEmpty) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tasks',
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF505050),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'You have ${_filterTasks().length} Tasks Today',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _filterTasks().length,
                              itemBuilder: (context, index) {
                                final task = _filterTasks()[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
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
                                    child: Container(
                                      height: 120,
                                      child: buildTaskDetailBox(
                                        task.title,
                                        task.description,
                                        Colors.white,
                                        task.priority,
                                        task.status,
                                        task.date,
                                        task.location,
                                        task.Event,
                                        task.Assignedby,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ] else ...[
                          // Show message if no tasks are available
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'No tasks available',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],

                        // Meetings Section
                        if (_filterMeetings().isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Meetings',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF505050),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'You have ${_filterMeetings().length} Meetings Today',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                SingleChildScrollView(
                                  child: Column(
                                    children: _filterMeetings().map((meeting) {
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
                                                date: meeting.fromDate,
                                                location: meeting.location,
                                                pdfUrls: meeting.pdfUrls,
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
                                          meeting.Assignedby,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Show message if no meetings are available
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'No meetings available',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ],
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
  List<Task> _filterTasks() {
    if (searchQuery.isEmpty) return _homePageData.tasks;

    return _homePageData.tasks.where((task) {
      return [
        task.title.toLowerCase(),
        task.description.toLowerCase(),
        task.priority.toString().toLowerCase(), // Ensure it's a String
        task.status.toString().toLowerCase(),   // Ensure it's a String
        task.date.toString().toLowerCase(),     // Ensure it's a String
        task.location.toLowerCase(),
        task.Event.toString().toLowerCase(),    // Ensure it's a String
        task.Assignedby.toLowerCase(),
      ].any((field) => field.contains(searchQuery.toLowerCase()));
    }).toList();
  }

  List<Meeting> _filterMeetings() {
    if (searchQuery.isEmpty) return _homePageData.meetings;

    return _homePageData.meetings.where((meeting) {
      return [
        meeting.title.toLowerCase(),
        meeting.description.toLowerCase(),
        meeting.priority.toString().toLowerCase(), // Ensure it's a String
        meeting.status.toString().toLowerCase(),   // Ensure it's a String
        meeting.fromDate.toString().toLowerCase(), // Ensure it's a String
        meeting.toDate.toString().toLowerCase(),   // Ensure it's a String
        meeting.fromTime.toString().toLowerCase(), // Ensure it's a String
        meeting.toTime.toString().toLowerCase(),   // Ensure it's a String
        meeting.location.toLowerCase(),
        meeting.Assignedby.toLowerCase(),
      ].any((field) => field.contains(searchQuery.toLowerCase()));
    }).toList();
  }


  Widget _buildFilterButton(String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _viewFilter =
              label; // Update the view filter based on the button pressed
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _viewFilter == label ? AppColors.concolor : Colors.grey,
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }


  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _suggestions = _getSuggestions(query);
    });
  }

  List<String> _getSuggestions(String query) {
    if (query.isEmpty) return [];

    // Use a Set to avoid duplicates
    final combinedSet = <String>{};

    // Add task titles, locations, Assignedby, priority, status, and date
    for (var task in _homePageData.tasks) {
      combinedSet.add(task.title);
      combinedSet.add(task.location);
      combinedSet.add(task.Assignedby);
      combinedSet.add(task.priority.toString());
      combinedSet.add(task.status.toString());
      combinedSet.add(task.date.toString());
    }

    // Add meeting titles, locations, Assignedby, and priority
    for (var meeting in _homePageData.meetings) {
      combinedSet.add(meeting.title);
      combinedSet.add(meeting.location);
      combinedSet.add(meeting.Assignedby);
      combinedSet.add(meeting.priority.toString());
      combinedSet.add(meeting.status.toString());
    }

    // Convert the Set back to a List and filter suggestions based on the query
    return combinedSet.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
  }

}
