import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttm/Comman_pages/Constant.dart';
import '../Profile_Pages/Profile_page.dart';
import '../Comman_pages/Widgets_page.dart';


Widget buildFilterButton(String text, String selectedButton, Function onPressed) {
  return SizedBox(
    width: 100,
    child: ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, // Remove internal padding
        backgroundColor: selectedButton == text ? AppColors.concolor : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: AppColors.concolor,
            width: 1,
          ),
        ),
        minimumSize: const Size(100, 45),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center, // Center the text horizontally
          style: GoogleFonts.montserrat(
            color: selectedButton == text ? Colors.white : AppColors.concolor,
            fontSize: 14, // Adjust the font size as needed
            fontWeight: FontWeight.normal, // Change to bold for better visibility
          ),
        ),
      ),
    ),
  );
}



Widget buildTaskBox(String title, Color color, double width, double height, int taskCount, IconData iconData) {
  return Container(
    width: width,
    height: height,
    margin: const EdgeInsets.only (left: 0.0),
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

Widget buildTaskDetailBox(
    String title,
    String description,
    Color color,
    String priority,
    String status,
    DateTime date,
    String location,
    String event,
    String assignedby)
{
  return Container(
    width: 260,
    height: 170, // Increased height to prevent overflow
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 3,
          blurRadius: 1,
          offset: const Offset(0, 0),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (priority != null)
              Container(
                margin: const EdgeInsets.only(left: 4.00),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: getPriorityColor(priority),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  priority,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            if (assignedby != null && assignedby == "HQ")
              Container(
                margin: const EdgeInsets.only(left: 4.00),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.concolor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  assignedby,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.grey,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: AppColors.concolor),
            const SizedBox(width: 4),
            Text(
              "${date.day}/${date.month}/${date.year}",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          status,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 10),

        // Progress rectangles
        Row(
          children: List.generate(3, (index) {
            Color rectangleColor;
            if (status == "In Progress") {
              rectangleColor = index < 2 ? Colors.orange : Colors.grey;
            } else if (status == "Overdue") {
              rectangleColor = index < 2 ? Colors.red : Colors.grey;
            } else if (status == "Not Started") {
              rectangleColor = index < 2 ? Colors.grey : Colors.grey;
            } else {
              rectangleColor = index < 3 ? Colors.green : Colors.grey;
            }

            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Container(
                width: 72,
                height: 6,
                decoration: BoxDecoration(
                  color: rectangleColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: AppColors.concolor),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // Wrap the Row in a Container with a defined width
            Container(
              width: 70, // Set a width that fits your layout
              child: Row(
                children: [

                  Flexible(
                    child: Text(
                      "[$event]",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: AppColors.concolor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Function to build the meeting detail box
Widget buildMeetingDetailBox(
    String title,
    String description,
    Color color,
    String priority,
    String status,
    DateTime fromDate,
    DateTime toDate,
    String fromTime,
    String toTime,
    String location,
    String assignedby,
    ) {
  return Container(
    width: 400,
    height: 120,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Priority Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (priority != null)
              Container(
                margin: const EdgeInsets.only(left: 4.00),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: getPriorityColor(priority),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  priority,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            if (assignedby != null && assignedby == "HQ")
              Container(
                margin: const EdgeInsets.only(left: 4.00),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.concolor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  assignedby,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 3), // Optional, adjust spacing as needed

        // Calendar Icon, From and To Dates, Time Icon, From and To Times
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Calendar with From and To Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.concolor),
                const SizedBox(width: 4),
                Text(
                  "${fromDate.day}/${fromDate.month}/${fromDate.year} - ${toDate.day}/${toDate.month}/${toDate.year}",
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // Time Icon with From and To Time
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: AppColors.concolor),
                const SizedBox(width: 4),
                Text(
                  "$fromTime - $toTime",
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Dashed line separator
        CustomPaint(
          size: Size(double.infinity, 1), // Width and height of the dashed line
          painter: DashedLinePainter(),
        ),

        const SizedBox(height: 8),

        // Row for address on the left and status on the right
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Address on the left
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: AppColors.concolor),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // Status on the right
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusColor(status ), // Use the getStatusColor function
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: getStatusTextColor(status), // Use the getStatusTextColor function
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Function to get the status text color
Color getStatusTextColor(String status) {
  if (status == "In Progress") {
    return Colors.white;
  } else if (status == "Completed") {
    return Colors.white;
  } else if (status == "Not started") {
    return Colors.white;
  } else {
    return Colors.black; // Default color for any other status
  }
}


// Method to handle menu item selection
void onMenuItemSelected(String value, BuildContext context) {
  AuthService authService = AuthService();
  switch (value) {
    case 'profile':
    // Navigate to profile page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to ProfilePage
      );
      break;
    case 'notification':
    // Navigate to notification page
      print('Notification selected');
      break;
    case 'help':
    // Navigate to help page
      print('Help selected');
      break;
    case 'logout':
    // Handle logout
      authService.showLogoutConfirmationDialog(context);
      print('Logout selected');
      break;
    default:
      break;
  }


}

Widget buildTaskDetailBoxforhome(
    String title,
    String description,
    Color color,
    String priority,
    String status,
    DateTime date,
    String location,
    String event,
    String assignedBy, // New parameter for the assigned by text
    ) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 120,
          decoration: BoxDecoration(
            color: getPriorityColor(priority ?? 'Medium'),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: 0),
        Expanded(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title, Priority, and Assigned By in one row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (priority != null)
                          Container(
                            margin: const EdgeInsets.only(left: 4.00),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: getPriorityColor(priority),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              priority,
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        if (assignedBy != null && assignedBy == "HQ")
                          Container(
                            margin: const EdgeInsets.only(left: 4.00),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.concolor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              assignedBy,
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            description,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8), // Add some space between the text and the icon
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.concolor,
                          size: 16,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: AppColors.concolor),
                        const SizedBox(width: 4),
                        Text(
                          '${date.toLocal()}'.split(' ')[0], // Format date as needed
                          style: GoogleFonts.montserrat(
                              fontSize: 10, color: Colors.black),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on,
                            size: 16, color: AppColors.concolor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
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
              Positioned(
                top: 1,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "[$event]",
                    style: GoogleFonts.montserrat(
                        fontSize: 10, color: AppColors.concolor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}