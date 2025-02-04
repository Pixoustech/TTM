import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ttm/Comman_pages/Constant.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Event_Detail_Pages/Event_Detail.dart';
import '../Comman_pages/Widgets_page.dart';
import '../Profile_Pages/Service.dart';
import 'Home_page_Widgets.dart';
import 'Service.dart';
import 'model.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';

class HomePageData {
  final List<Task> tasks;
  final List<Meeting> meetings;

  HomePageData({required this.tasks, required this.meetings});
}

class HomePageDatastatusbased {
  final List<Task> tasks;
  final List<Meeting> meetings;

  HomePageDatastatusbased({required this.tasks, required this.meetings});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isLoadingoverall = true; // Add this line
  bool _isLoading = true; // Add this line
  String buttonText = "Check In";
  String _selectedButton = 'Today';
  HomePageData _homePageData =
      HomePageData(tasks: [], meetings: []); // Initialize with empty lists
  HomePageDatastatusbased _homePageDatastatusbased =
      HomePageDatastatusbased(tasks: [], meetings: []);
  String greetingMessage = '';
  String searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  String _viewFilter = 'All';
  List<String> _suggestions = [];
  final String userId = AppConstants.userId ?? '';
  late DataService _dataService;
  int notStartedCount = 0;
  int inProgressCount = 0;
  int completedCount = 0;
  int overdueCount = 0;
  XFile? _imageFile; // Variable to hold the selected image
  @override
  void initState() {
    super.initState();
    _setGreetingMessage();
    _dataService = DataService(userId);
    _fetchData('today'); // Fetch today's data on page load
    _fetchData1();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<void> _fetchUserProfile() async {
    final userService = ApiService();
    try {
      final fetchedProfile = await userService.fetchUserProfile(AppConstants.userId ?? '');

      // Ensure the fetched data is not null or empty before updating the UI
      setState(() {
        if (fetchedProfile != null && fetchedProfile.profileImageId.isNotEmpty) {
          // Update the profile image if available
          _imageFile = XFile('http://ttm.dev.pixous.info/images/${fetchedProfile.profileImageId}');
        }
      });
    } catch (e) {
      // Handle any exceptions (e.g., network error)
      print('Error fetching user profile: $e');
      // Optionally, show a message to the user or log the error
    }
  }

  void _toggleCheckInOut() async {
    // Request location permission
    LocationPermission permission = await LocationRequest.requestLocationPermission();

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // Get the user's location
      Position position = await LocationRequest.getCurrentLocation();

      if (position != null) {
        // Determine check-in or check-out action based on the current button text
        if (buttonText == "Check In") {
          // Handle check-in logic
          print("User  checked in at: ${position.latitude}, ${position.longitude}");

          // Allow user to take a picture
          final ImagePicker _picker = ImagePicker();
          XFile? image = await _picker.pickImage(source: ImageSource.camera);

          if (image != null) {
            // Handle the image (e.g., upload it to the server)
            print("Image taken: ${image.path}");
            // You can upload the image to your server here
          } else {
            print("No image selected.");
          }
        } else {
          // Handle check-out logic
          print("User  checked out at: ${position.latitude}, ${position.longitude}");
        }

        // Toggle the button text
        setState(() {
          buttonText = (buttonText == "Check In") ? "Check Out" : "Check In";
        });
      }
    } else {
      // Handle permission denied case
      print("Location permission denied");
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Permission Denied"),
          content: Text("Please enable location services in settings to use this feature."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _openLocationSettings(); // Open app settings
              },
              child: Text("Settings"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openLocationSettings() async {
    await openAppSettings();
  }

  Future<void> _fetchData(String filterType) async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final data = await _dataService.fetchData(filterType);
      setState(() {
        _homePageData = data;

        // Calculate counts
        notStartedCount = _homePageData.tasks
            .where((task) => task.statusName.toLowerCase() == 'not started')
            .length;
        inProgressCount = _homePageData.tasks
            .where((task) => task.statusName.toLowerCase() == 'in-progress')
            .length;
        completedCount = _homePageData.tasks
            .where((task) => task.statusName.toLowerCase() == 'completed')
            .length;
        overdueCount = _homePageData.tasks
            .where((task) => task.statusName.toLowerCase() == 'overdue')
            .length;
      });
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _fetchData1() async {
    setState(() {
      _isLoadingoverall = true; // Start loading
    });

    try {
      final data = await _dataService.fetchData1();
      setState(() {
        _homePageDatastatusbased = data;
      });
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoadingoverall = false; // Stop loading
      });
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Reset counts
      notStartedCount = 0;
      inProgressCount = 0;
      completedCount = 0;
      overdueCount = 0;

      buttonText = "Check In"; // Reset button text
      _selectedButton = 'Today'; // Reset selected button
      searchQuery = ''; // Clear search query
      _searchController.clear(); // Clear the search box
      _setGreetingMessage(); // Reset greeting message
    });

    // Fetch today's data and additional data concurrently
    await Future.wait([
      _fetchData('today'),
      _fetchData1(),
    ]);
  }

  HomePageData getDefaultHomePageData() {
    // Return an instance of HomePageData with empty lists or some default data
    return HomePageData(tasks: [], meetings: []);
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
                              icon: _imageFile != null
                                  ? CircleAvatar(
                                backgroundImage: NetworkImage(_imageFile!.path),
                                radius: 20, // Adjust the size to match the icon size
                              )
                                  : Icon(Icons.account_circle, size: 40, color: AppColors.concolor),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
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
                                          prefixIcon: Icon(Icons.search,
                                              color: AppColors.concolor),
                                          hintText: 'Search',
                                          hintStyle: GoogleFonts.montserrat(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                                searchQuery =
                                                    _suggestions[index];
                                                _searchController.text =
                                                    searchQuery;
                                                _suggestions
                                                    .clear(); // Clear suggestions after selection
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
                  padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 10.0,
                      right: 10.0,
                      bottom:
                          50.0), // Set padding for top, left, and right only
                  child: Column(
                    children: [
                      if (_filterTasksstatusbasedbox().isNotEmpty ||
                          _filterMeetingsstatusbasedbox().isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAEAEA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 220,
                                  child: _isLoadingoverall
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                6, // Number of shimmer items
                                            itemBuilder: (context, index) {
                                              return Container(
                                                width: 120,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _filterTasksstatusbasedbox()
                                                  .length +
                                              _filterMeetingsstatusbasedbox()
                                                  .length,
                                          itemBuilder: (context, index) {
                                            if (index <
                                                _filterTasksstatusbasedbox()
                                                    .length) {
                                              final task =
                                                  _filterTasksstatusbasedbox()[
                                                      index];
                                              if (task.statusName
                                                          .toLowerCase() ==
                                                      'overdue' ||
                                                  task.statusName
                                                          .toLowerCase() ==
                                                      'in-progress') {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 3.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EventDetailPage(
                                                            title:
                                                                task.eventName,
                                                            description: task
                                                                .description,
                                                            priority:
                                                                task.priority,
                                                            status:
                                                                task.statusName,
                                                            date: task.dueDate,
                                                            location:
                                                                task.location,
                                                            pdfUrls:
                                                                task.pdfUrls ??
                                                                    [],
                                                            Event:
                                                                task.eventType,
                                                            Assignedby:
                                                                task.isSelfEvent
                                                                    ? "Own"
                                                                    : "HQ",
                                                            Attachmentpdfurl: task
                                                                .attachmentPdfUrls,
                                                            fromDate:
                                                                task.dueDate,
                                                            toDate:
                                                                task.dueDate,
                                                            fromTime: "",
                                                            toTime: "",
                                                            id: task.id,
                                                            eventmode: '',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 120,
                                                      child:
                                                          buildTaskDetailBoxforall(
                                                        task.eventName,
                                                        task.description,
                                                        Colors.white,
                                                        task.priority,
                                                        task.statusName,
                                                        task.dueDate,
                                                        task.location,
                                                        task.eventType,
                                                        task.isSelfEvent
                                                            ? ""
                                                            : "HQ",
                                                        task.eventType,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            } else {
                                              final meetingIndex = index -
                                                  _filterTasksstatusbasedbox()
                                                      .length;
                                              final meeting =
                                                  _filterMeetingsstatusbasedbox()[
                                                      meetingIndex];
                                              if (meeting.statusName
                                                          .toLowerCase() ==
                                                      'overdue' ||
                                                  meeting.statusName
                                                          .toLowerCase() ==
                                                      'in-progress') {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EventDetailPage(
                                                            title: meeting
                                                                .eventName,
                                                            description: meeting
                                                                .description,
                                                            priority: meeting
                                                                .priority,
                                                            status: meeting
                                                                .statusName,
                                                            date: meeting
                                                                .startDate,
                                                            location:
                                                                meeting.venue,
                                                            pdfUrls:
                                                                meeting.pdfUrls,
                                                            Event: meeting
                                                                .eventType,
                                                            Assignedby: meeting
                                                                    .isSelfEvent
                                                                ? "Own"
                                                                : "HQ",
                                                            Attachmentpdfurl:
                                                                meeting
                                                                    .attachmentPdfUrls,
                                                            fromDate: meeting
                                                                .startDate,
                                                            toDate:
                                                                meeting.endDate,
                                                            fromTime: meeting
                                                                .fromTime,
                                                            toTime:
                                                                meeting.toTime,
                                                            id: meeting.id,
                                                            eventmode: meeting
                                                                .eventMode,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 120,
                                                      child:
                                                          buildTaskDetailBoxforall(
                                                        meeting.eventName,
                                                        meeting.description,
                                                        Colors.white,
                                                        meeting.priority,
                                                        meeting.statusName,
                                                        meeting.startDate,
                                                        meeting.venue,
                                                        meeting.eventType,
                                                        meeting.isSelfEvent
                                                            ? ""
                                                            : "HQ",
                                                        meeting.eventType,
                                                        fromDate:
                                                            meeting.startDate,
                                                        toDate: meeting.endDate,
                                                        fromTime:
                                                            meeting.fromTime,
                                                        toTime: meeting.toTime,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
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
                            _fetchData(
                                'previous'); // Call the API with 'previous' filter
                          }),
                          const SizedBox(width: 10),
                          buildFilterButton('Today', _selectedButton, () {
                            setState(() {
                              _selectedButton = 'Today';
                            });
                            _fetchData(
                                'today'); // Call the API with 'today' filter
                          }),
                          const SizedBox(width: 10),
                          buildFilterButton('Upcoming', _selectedButton, () {
                            setState(() {
                              _selectedButton = 'Upcoming';
                            });
                            _fetchData(
                                'next'); // Call the API with 'upcoming' filter
                          }),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppWidgets.divider(),
                      if (_isLoading) ...[
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10.0),
                            child: Column(
                              // Use Column to stack the two rows
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 90,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 90,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height:
                                        10), // Add some space between the rows
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 90,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 90,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: buildTaskBox(
                                    'Not Started',
                                    Colors.grey,
                                    double.infinity,
                                    90,
                                    notStartedCount,
                                    Icons.pending),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: buildTaskBox(
                                    'In-Progress',
                                    Colors.orange,
                                    double.infinity,
                                    90,
                                    inProgressCount,
                                    Icons.rotate_left),
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
                                child: buildTaskBox(
                                    'Completed',
                                    Colors.green,
                                    double.infinity,
                                    90,
                                    completedCount,
                                    Icons.check_circle),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: buildTaskBox(
                                    'Overdue',
                                    Color(0xFFC52D28),
                                    double.infinity,
                                    90,
                                    overdueCount,
                                    Icons.timer),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFilterButton('All'),
                            _buildFilterButton('Tasks'),
                            _buildFilterButton('Meetings'),
                          ],
                        ),
                      ),
                      if (_viewFilter == 'Tasks') ...[
                        if (_isLoading) ...[
                          // Shimmer loading for meetings
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: 5, // Number of shimmer items
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 120,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ] else ...[
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
                                            builder: (context) =>
                                                EventDetailPage(
                                              title: task.eventName,
                                              description: task.description,
                                              priority: task.priority,
                                              status: task.statusName,
                                              date: task.dueDate,
                                              location: task.location,
                                              pdfUrls: task.pdfUrls ?? [],
                                              Event: task.eventType,
                                              Assignedby: task.isSelfEvent
                                                  ? "Own"
                                                  : "HQ",
                                              Attachmentpdfurl:
                                                  task.attachmentPdfUrls,
                                              fromDate: task.dueDate,
                                              toDate: task.dueDate,
                                              fromTime: "",
                                              toTime: "",
                                              id: task.id,
                                              eventmode: '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: buildTaskDetailBox(
                                          title: task.eventName,
                                          description: task.description,
                                          priority: task.priority,
                                          date: task.dueDate, // Format date
                                          location: task.location,
                                          event: task.eventType,
                                          assignedBy:
                                              task.isSelfEvent ? "" : "HQ",
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                        ],
                      ],
                      if (_viewFilter == 'Meetings') ...[
                        if (_isLoading) ...[
                          // Shimmer loading for meetings
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: 5, // Number of shimmer items
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 120,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Meetings',
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
                                              builder: (context) =>
                                                  EventDetailPage(
                                                title: meeting.eventName,
                                                description:
                                                    meeting.description,
                                                priority: meeting.priority,
                                                status: meeting.statusName,
                                                date: meeting.startDate,
                                                location: meeting.venue,
                                                pdfUrls: meeting.pdfUrls,
                                                Event: meeting.eventType,
                                                Assignedby: meeting.isSelfEvent
                                                    ? "Own"
                                                    : "HQ",
                                                Attachmentpdfurl:
                                                    meeting.attachmentPdfUrls,
                                                fromDate: meeting.startDate,
                                                toDate: meeting.endDate,
                                                fromTime: meeting.fromTime,
                                                toTime: meeting.toTime,
                                                id: meeting.id,
                                                eventmode: meeting.eventMode,
                                              ),
                                            ),
                                          );
                                        },
                                        child: buildMeetingDetailBox(
                                          title: meeting.eventName,
                                          description: meeting.description,
                                          priority: meeting.priority,
                                          status: meeting.statusName,
                                          fromDate: meeting.startDate,
                                          toDate: meeting.endDate,
                                          fromTime: meeting.fromTime,
                                          toTime: meeting.toTime,
                                          location: meeting.venue,
                                          event: meeting.eventType,
                                          assignedby:
                                              meeting.isSelfEvent ? "" : "HQ",
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                      if (_viewFilter == 'All') ...[
                        // Tasks Section
                        if (_isLoading) ...[
                          // Shimmer loading for tasks
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5, // Number of shimmer items
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 300,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ] else if (_filterTasks().isNotEmpty) ...[
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
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: GestureDetector(
                                    onTap: () {
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
                                            Assignedby:
                                                task.isSelfEvent ? "Own" : "HQ",
                                            Attachmentpdfurl:
                                                task.attachmentPdfUrls,
                                            fromDate: task.dueDate,
                                            toDate: task.dueDate,
                                            fromTime: "",
                                            toTime: "",
                                            id: task.id,
                                            eventmode: '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 120,
                                      child: buildTaskDetailBoxforall(
                                        task.eventName,
                                        task.description,
                                        Colors.white,
                                        task.priority,
                                        task.statusName,
                                        task.dueDate,
                                        task.location,
                                        task.eventType,
                                        task.isSelfEvent ? "" : "HQ",
                                        task.eventType,
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
                        if (_isLoading) ...[
                          // Shimmer loading for meetings
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                5,
                                (index) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 80,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ] else if (_filterMeetings().isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 10.0),
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
                                              builder: (context) =>
                                                  EventDetailPage(
                                                title: meeting.eventName,
                                                description:
                                                    meeting.description,
                                                priority: meeting.priority,
                                                status: meeting.statusName,
                                                date: meeting.startDate,
                                                location: meeting.venue,
                                                pdfUrls: meeting.pdfUrls,
                                                Event: meeting.eventType,
                                                Assignedby: meeting.isSelfEvent
                                                    ? "Own"
                                                    : "HQ",
                                                Attachmentpdfurl:
                                                    meeting.attachmentPdfUrls,
                                                fromDate: meeting.startDate,
                                                toDate: meeting.endDate,
                                                fromTime: meeting.fromTime,
                                                toTime: meeting.toTime,
                                                id: meeting.id,
                                                eventmode: meeting.eventMode,
                                              ),
                                            ),
                                          );
                                        },
                                        child: buildMeetingDetailBox(
                                          title: meeting.eventName,
                                          description: meeting.description,
                                          priority: meeting.priority,
                                          status: meeting.statusName,
                                          fromDate: meeting.startDate,
                                          toDate: meeting.endDate,
                                          fromTime: meeting.fromTime,
                                          toTime: meeting.toTime,
                                          location: meeting.venue,
                                          event: meeting.eventType,
                                          assignedby:
                                              meeting.isSelfEvent ? "" : "HQ",
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
    if (searchQuery.isEmpty) return _homePageDatastatusbased.tasks;
    return _homePageData.tasks.where((task) {
      return [
        task.eventName.toLowerCase(),
        task.description.toLowerCase(),
        task.priority.toString().toLowerCase(), // Ensure it's a String
        task.statusName.toString().toLowerCase(), // Ensure it's a String
        task.dueDate.toString().toLowerCase(), // Ensure it's a String
        task.location.toLowerCase(),
        task.eventType.toString().toLowerCase(), // Ensure it's a String
        task.isSelfEvent ? "" : "HQ".toLowerCase(),
      ].any((field) => field.contains(searchQuery.toLowerCase()));
    }).toList();
  }

  List<Meeting> _filterMeetings() {
    if (searchQuery.isEmpty) return _homePageData.meetings;

    return _homePageData.meetings.where((meeting) {
      return [
        meeting.eventName.toLowerCase(),
        meeting.description.toLowerCase(),
        meeting.priority.toString().toLowerCase(), // Ensure it's a String
        meeting.statusName.toString().toLowerCase(), // Ensure it's a String
        meeting.startDate.toString().toLowerCase(), // Ensure it's a String
        meeting.endDate.toString().toLowerCase(), // Ensure it's a String
        meeting.fromTime.toString().toLowerCase(), // Ensure it's a String
        meeting.toTime.toString().toLowerCase(), // Ensure it's a String
        meeting.venue.toLowerCase(),
        meeting.isSelfEvent ? "" : "HQ".toLowerCase(),
      ].any((field) => field.contains(searchQuery.toLowerCase()));
    }).toList();
  }

  List<Task> _filterTasksstatusbasedbox() {
    if (searchQuery.isEmpty) return _homePageDatastatusbased.tasks;
    return _homePageDatastatusbased.tasks.where((task) {
      return [
        task.eventName.toLowerCase(),
        task.description.toLowerCase(),
        task.priority.toString().toLowerCase(), // Ensure it's a String
        task.statusName.toString().toLowerCase(), // Ensure it's a String
        task.dueDate.toString().toLowerCase(), // Ensure it's a String
        task.location.toLowerCase(),
        task.eventType.toString().toLowerCase(), // Ensure it's a String
        task.isSelfEvent ? "" : "HQ".toLowerCase(),
      ].any((field) => field.contains(searchQuery.toLowerCase()));
    }).toList();
  }

  List<Meeting> _filterMeetingsstatusbasedbox() {
    if (searchQuery.isEmpty) return _homePageDatastatusbased.meetings;

    return _homePageDatastatusbased.meetings.where((meeting) {
      return [
        meeting.eventName.toLowerCase(),
        meeting.description.toLowerCase(),
        meeting.priority.toString().toLowerCase(), // Ensure it's a String
        meeting.statusName.toString().toLowerCase(), // Ensure it's a String
        meeting.startDate.toString().toLowerCase(), // Ensure it's a String
        meeting.endDate.toString().toLowerCase(), // Ensure it's a String
        meeting.fromTime.toString().toLowerCase(), // Ensure it's a String
        meeting.toTime.toString().toLowerCase(), // Ensure it's a String
        meeting.venue.toLowerCase(),
        meeting.isSelfEvent ? "" : "HQ".toLowerCase(),
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
      combinedSet.add(task.eventName);
      combinedSet.add(task.location);
      combinedSet.add(task.isSelfEvent ? "" : "HQ");
      combinedSet.add(task.priority.toString());
      combinedSet.add(task.statusName.toString());
      combinedSet.add(task.dueDate.toString());
    }

    // Add meeting titles, locations, Assignedby, and priority
    for (var meeting in _homePageData.meetings) {
      combinedSet.add(meeting.eventName);
      combinedSet.add(meeting.venue);
      combinedSet.add(meeting.isSelfEvent ? "" : "HQ");
      combinedSet.add(meeting.priority.toString());
      combinedSet.add(meeting.statusName.toString());
    }

    // Convert the Set back to a List and filter suggestions based on the query
    return combinedSet
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}