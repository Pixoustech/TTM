// lib/constants/app_constants.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color concolor = Color(0xFF7E1416);
  static const Color backwhite = Color(0xFFFFFFFF);
}
class AppWidgets {
  // Method to return a Divider widget
  static Divider divider() {
    return const Divider(
      color: Colors.grey, // Color of the divider
      thickness: 1, // Thickness of the divider
      height: 20, // Space above and below the divider
    );
  }
}
