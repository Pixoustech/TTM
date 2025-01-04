import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Home_Page/Home_page_Widgets.dart';
import 'Constant.dart';

class AppWidgets {
  // Method to return a Divider widget
  static Widget divider({double width = 270.0}) {
    return Container(
      width: width, // Set the desired width here
      child: const Divider(
        color: Colors.grey, // Color of the divider
        thickness: 1, // Thickness of the divider
        height: 20, // Space above and below the divider
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget buildTaskDetailBox({
  required String title,
  required String description,
  String? priority,
  required String date,
  required String location,
  required String event,
  required String assignedBy,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 130,
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
                height: 130,
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
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, -2), // Shadow towards the top
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
                            margin: const EdgeInsets.only(
                                left: 6.0), // Adjust margin as needed
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
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
                    Expanded(
                      child: Row(
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
                          const SizedBox(
                              width:
                                  8), // Add some space between the text and the icon
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.concolor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: AppColors.concolor),
                        const SizedBox(width: 4),
                        Text(

                          '${formatDate(date ?? '')}',
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
              // Positioned event text in the top-right corner
              Positioned(
                top: 1,
                right: 8,
                child: Text(
                  "[$event]",
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.concolor,
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

Widget buildMeetingDetailBox({
  required String title,
  required String description,
  required String priority,
  required String status,
  required String fromDate,
  required String toDate,
  required String fromTime,
  required String toTime,
  required String location,
  required String assignedby,
  required String event,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Colored side indicator
      Container(
        width: 10,
        height: 130,
        decoration: BoxDecoration(
          color: getPriorityColor(priority),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
      ),

      // Main meeting detail box
      Expanded(
        child: Container(
          width: 10,
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
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
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (priority.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(left: 4.0),
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
                      if (assignedby.isNotEmpty && assignedby == "HQ")
                        Container(
                          margin: const EdgeInsets.only(left: 4.0),
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
                  const SizedBox(height: 3),
                  // Description Row with ellipsis
                  Text(
                    description,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  // Calendar Icon, From and To Dates, Time Icon, From and To Times
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: AppColors.concolor),
                          const SizedBox(width: 4),
                          Text(
                            "${formatDate(fromDate)} - ${formatDate(toDate)}",
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Dashed line separator
                  CustomPaint(
                    size: Size(double.infinity, 1),
                    painter: DashedLinePainter(),
                  ),
                  const SizedBox(height: 8),
                  // Show location row if location is not empty
                  if (location.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: AppColors.concolor),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            location,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  // Status Row
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(status),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: getStatusTextColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
              // Conditionally display the event text in the top-right corner
              if (event.isNotEmpty)
                Positioned(
                  top: 1,
                  right: 2,
                  child: Text(
                    "[$event]",
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.concolor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
  );
}






/*
Widget buildMeetingDetailBox({
  required String title,
  required String description,
  required String priority,
  required String status,
  required DateTime fromDate,
  required DateTime toDate,
  required String fromTime,
  required String toTime,
  required String location,
  required String assignedby,
  required String event,
}) {
  return Container(
    width: 400,
    height: 120,
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
    decoration: BoxDecoration(
      color: Colors.white,
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
    child: Row(
      children: [
        // Priority Color Container on the left
        Container(
          width: 10,
          height: 120,
          decoration: BoxDecoration(
            color: getPriorityColor(priority), // Get color based on priority
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        // Main Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
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
                        if (priority.isNotEmpty)
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
                        if (assignedby.isNotEmpty && assignedby == "HQ")
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
                    const SizedBox(height: 6),
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
                      size: Size(double.infinity, 1),
                      painter: DashedLinePainter(),
                    ),
                    const SizedBox(height: 8),
                    // Row for address on the left and status on the right
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: getStatusColor(status),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: getStatusTextColor(status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Conditionally display the event text in the top-right corner
                if (event.isNotEmpty)
                  Positioned(
                    top: 1,
                    right: 2,
                    child: Text(
                      "[$event]",
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.concolor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}*/
