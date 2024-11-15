// lib/constants/app_constants.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color concolor = Color(0xFF7E1416);
  static const Color backwhite = Color(0xFFFFFFFF);
}

class AppApi {
  static const String baseUrl = 'https://ttmdev.pixoustech.in/App/api'; // Replace with your actual base URL
}
// Function to get the status background color
Color getStatusColor(String status) {
  if (status == "In Progress") {
    return Colors.orange;
  } else if (status == "Completed") {
    return Colors.green;
  }
  else if (status == "Not Started")
  {
    return Colors.grey;
  }
  else if (status == "Overdue")
  {
    return Colors.red;
  }
  else {
    return Colors.blue; // Default color for any other status
  }
}


Color getPriorityColor(String priority) {
  switch (priority) {
    case 'High':
      return Colors.red;
    case 'Medium':
      return Color(0xFFFFC107);
    case 'Low':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
