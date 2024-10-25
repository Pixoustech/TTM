import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttm/Constant.dart';

Widget buildFilterButton(String text, String selectedButton, Function onPressed) {
  return SizedBox(
    width: 100,
    child: ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedButton == text ? AppColors.concolor : Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
          style: GoogleFonts.montserrat(
            color: selectedButton == text ? Colors.white : AppColors.concolor,
            fontSize: 9,
            fontWeight: FontWeight.bold,
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
      borderRadius: BorderRadius.circular(12),
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

Widget buildTaskDetailBox(String title, String description, Color color, String priority, String status, DateTime date, String location) {
  return Container(
    width: 260,
    height: 100,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
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
        const SizedBox(height: 8),
        Text(
          status,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
          ],
        ),
      ],
    ),
  );
}

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
    String location) {
  return Container(
    width: 400,
    height: 150, // Increased height for added content
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Priority Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Space between title and priority
          children: [
            // Title on the left
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Priority on the right
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
          ],
        ),
        const SizedBox(height: 8),

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

        // Status
        Text(
          status,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        // Location Icon and Text
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey),
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
      ],
    ),
  );
}


Color getPriorityColor(String priority) {
  switch (priority) {
    case 'High':
      return Colors.red;
    case 'Medium':
      return Colors.orange;
    case 'Low':
      return Colors.green;
    default:
      return Colors.grey;
  }
}