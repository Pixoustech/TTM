import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure to import Google Fonts
import 'package:ttm/Constant.dart';

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Wrap the Column in SingleChildScrollView
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'Assets/Images/TTMlogo.png',
                          height: 100,
                          width: 100,
                        ),
                        IconButton(
                          icon: Icon(Icons.account_circle, size: 40, color: AppColors.concolor),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good Morning, John Harry M',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF505050),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Let’s get to work!",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _toggleCheckInOut,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.concolor,
                              minimumSize: const Size(double.infinity, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Container(
                                height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  cursorColor: AppColors.concolor,
                                  style: TextStyle(
                                    color: AppColors.concolor,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search, color: AppColors.concolor),
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Colors.grey),
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min, // Minimize the space taken by the row
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildFilterButton('Previous'),
                              const SizedBox(width: 10), // Adjust space between buttons
                              _buildFilterButton('Today'),
                              const SizedBox(width: 10),
                              _buildFilterButton('Upcoming'),
                            ],
                          ),
                          AppWidgets.divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align to the start (left)
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildTaskBox('Not Started', Colors.grey, double.infinity, 90, 5,Icons.pending),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: _buildTaskBox('In Progress', Colors.orange, double.infinity, 90, 10,Icons.rotate_left),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align to the start (left)
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: _buildTaskBox('Completed', Colors.green, double.infinity, 90, 10,Icons.check_circle),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: _buildTaskBox('Overdue', Color(0xFFC52D28), double.infinity, 90, 5,Icons.timer),
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
                                const Text(
                                  'TASK',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF505050),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'You have 3 Tasks Today',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 200, // Adjust height as needed
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      _buildTaskDetailBox(
                                        'App Design',
                                        'The current website design needs a refresh to improve user experience and enhance visual appeal.',
                                        Colors.white,
                                        'High',
                                        'In Progress',
                                        DateTime.now(), // Current date for the task
                                        'New York', // Location for the task
                                      ),
                                      const SizedBox(width: 10), // Space between boxes
                                      _buildTaskDetailBox(
                                        'App Development',
                                        'The current website design needs a refresh to improve user experience and enhance visual appeal.......',
                                        Colors.white,
                                        'Medium',
                                        'Overdue',
                                        DateTime.now().add(Duration(days: -2)), // Overdue date example
                                        'San Francisco', // Location for the task
                                      ),
                                      const SizedBox(width: 10),
                                      _buildTaskDetailBox(
                                        'Testing',
                                        'The current website design needs a refresh to improve user experience and enhance visual appeal',
                                        Colors.white,
                                        'Low',
                                        'Completed',
                                        DateTime.now().add(Duration(days: -1)), // Completed date example
                                        'Los Angeles', // Location for the task
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Optional spacing at the bottom
          ],
        ),
      ),
    );
  }


Widget _buildFilterButton(String text) {
    return SizedBox(
      width: 100, // Ensure this width is enough for your text
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedButton = text;
          });
          print('$text button pressed');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedButton == text
              ? AppColors.concolor
              : Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.concolor,
              width: 1,
            ),
          ),
          minimumSize: const Size(100, 45), // Ensure buttons are consistently sized
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: _selectedButton == text
                  ? Colors.white
                  : AppColors.concolor,
              fontSize: 10,
              fontWeight: FontWeight.w500, // Consider making the text a bit bolder
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTaskBox(String title, Color color, double width, double height, int taskCount, IconData iconData) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(left: 0.0), // Adjust the left margin as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the start (left)
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Add some padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5), // Space between title and count
                  Text(
                    '$taskCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add the icon to the right side of the box
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // Adjust padding as needed
            child: Icon(
              iconData,
              color: Colors.white,
              size: 24, // Adjust size as needed
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTaskDetailBox(String title, String description, Color color, String priority, String status,DateTime date, String location ) {
    return Container(
      width: 260, // Keep the width as needed
      height: 120, // Increase the height here to accommodate the rectangles
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread radius of the shadow
            blurRadius: 6, // Blur radius of the shadow
            offset: const Offset(0, 3), // Offset of the shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjusted padding
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align title and priority to opposite ends
            children: [
              Expanded( // Expanded to use available space
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16, // Font size for title
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // Add the priority text on the right side
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Decreased vertical padding
                decoration: BoxDecoration(
                  color: _getPriorityColor(priority), // Function to get the color based on priority
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priority,
                  style: const TextStyle(
                    fontSize: 10, // Adjusted font size if needed
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4), // Reduced space between title and description
          Text(
            description,
            style: const TextStyle(
              fontSize: 12, // Font size for description (can also be adjusted)
              color: Colors.grey,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis, // Ensure description uses ellipsis
          ),
          const SizedBox(height: 8), // Space between description and status
          Text(
            status, // Add the status text
            style: const TextStyle(
              fontSize: 12, // Font size for status
              color: Colors.black, // Function to get the color based on status
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8), // Space between status and rectangles
          if (status == "In Progress") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Two yellow rectangles
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  child: Container(
                    width: 60, // Width of each rectangle
                    height: 5, // Height of each rectangle
                    color: Colors.yellow, // Color of the first rectangle
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  child: Container(
                    width: 60, // Width of each rectangle
                    height: 5, // Height of each rectangle
                    color: Colors.yellow, // Color of the second rectangle
                  ),
                ),
                // One grey rectangle
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  child: Container(
                    width: 60, // Width of each rectangle
                    height: 5, // Height of each rectangle
                    color: Colors.grey, // Color of the third rectangle
                  ),
                ),
              ],
            ),
          ],
          if (status == "Overdue") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Two yellow rectangles
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  child: Container(
                    width: 60, // Width of each rectangle
                    height: 5, // Height of each rectangle
                    color: Colors.red, // Color of the first rectangle
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  child: Container(
                    width: 60, // Width of each rectangle
                    height: 5, // Height of each rectangle
                    color: Colors.red, // Color of the second rectangle
                  ),
                ),
                // One grey rectangle
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  child: Container(
                    width: 60, // Width of each rectangle
                    height: 5, // Height of each rectangle
                    color: Colors.grey, // Color of the third rectangle
                  ),
                ),
              ],
            ),
          ],
          if (status == "Completed") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Two yellow rectangles
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  child: Container(
                    width: 60, // Width of each rectangle
                    height: 5, // Height of each rectangle
                    color: Colors.green, // Color of the first rectangle
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  child: Container(
                    width: 60, // Width of each rectangle
                    height: 5, // Height of each rectangle
                    color: Colors.green, // Color of the second rectangle
                  ),
                ),
                // One grey rectangle
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  child: Container(
                    width: 60, // Width of each rectangle
                    height: 5, // Height of each rectangle
                    color: Colors.green, // Color of the third rectangle
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10), // Space between rectangles and date/location icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between icons
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16,color: AppColors.concolor,), // Date icon
                  const SizedBox(width: 4), // Space between icon and date
                  Text(
                    "${date.day}/${date.month}/${date.year}", // Display date
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16,color:AppColors.concolor), // Location icon
                  const SizedBox(width: 4), // Space between icon and location
                  Text(
                    location, // Display location
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red; // Red for high priority
      case 'Medium':
        return Colors.orange; // Orange for medium priority
      case 'Low':
        return Colors.green; // Green for low priority
      default:
        return Colors.grey; // Default color
    }
  }

  }
