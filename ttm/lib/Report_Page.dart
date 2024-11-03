import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Constant.dart';
import 'Navigation_page.dart';

class ReportPage extends StatelessWidget {
  // Sample data for task statuses
  final Map<String, int> _taskStatuses = {
    'Not Started': 5,
    'In Progress': 3,
    'Completed': 10,
    'Overdue': 6,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.concolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.backwhite),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Navigation()),
            );
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Report',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overview',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: 'Last 6 months',
                  items: <String>[
                    'Last 6 months',
                    'Last 12 months',
                    'Last 3 months'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle dropdown change
                  },
                ),
              ],
            ),
            SizedBox(height: 20), // Spacing between header and task boxes

            // Task Boxes
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
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
            SizedBox(height: 20), // Spacing before the Event Overview text
            Text(
              'Event Overview',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Change color as needed
              ),
            ),
            SizedBox(height: 10), // Spacing before the task status summary

            // Call the task status summary builder here
            _buildTaskStatusSummary(),
          ],
        ),
      ),
    );
  }

  Widget buildTaskBox(String title, Color color, double width, double height,
      int taskCount, IconData iconData) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(left: 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$taskCount',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStatusSummary() {
    // Format the dates

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Center the content
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _taskStatuses.keys.map((status) {
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
                backgroundColor = Colors
                    .grey[200]!; // Light orange background for In Progress
                break;
              case 'Completed':
                dotColor = Colors.green;
                backgroundColor =
                    Colors.grey[200]!; // Light green background for Completed
                break;
              default:
                dotColor = Colors.red;
                backgroundColor =
                    Colors.grey[200]!; // Light red background for default
            }

            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 1.0,
                  vertical: 4.0), // Add padding for better spacing
              margin: EdgeInsets.symmetric(
                  horizontal: 1.0), // Add margin between items
              child: Row(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Center the dot and text vertically
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 1), // Add space between the dot and the text
                  Text(
                    status, // Display just the status name
                    style: GoogleFonts.montserrat(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
