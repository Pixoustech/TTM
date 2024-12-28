// lib/constants/app_constants.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../MapScreen.dart';

class AppColors {
  static const Color concolor = Color(0xFF7E1416);
  static const Color backwhite = Color(0xFFFFFFFF);
}

class AppApi {
  static const String baseurl = "https://9069-2405-201-e02b-58e4-b927-a704-a2ba-3b0b.ngrok-free.app/api"; // Replace with your actual base URL

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseurl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}

class googlemapkey {
  static const String mapkey = 'AIzaSyByh8kxXcO3Q2_aPOQ0wZU0rSncLaWSlBQ';
}

class EventUtils {
  // Fetch address suggestions
  static Future<List<String>> fetchAddressSuggestions(String input, String apiKey) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> suggestions = [];
        for (var prediction in data['predictions']) {
          suggestions.add(prediction['description']);
        }
        return suggestions; // Return suggestions
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
      return []; // Return an empty list on error
    }
  }

  static Future<LatLng?> selectLocation(BuildContext context) async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      final LatLng? selectedLocation = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapWithStreetViewPage()),
      );
      return selectedLocation;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission denied')),
      );
      return null;
    }
  }
}
class AppConstants {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getter to retrieve userId
  static String? get userId {
    return _prefs?.getString('userId');
  }
}

Color getStatusColor(String status) {
  if (status == "In-Progress") {
    return Colors.orange;
  } else if (status == "Completed") {
    return Colors.green;
  } else if (status == "Not Started") {
    return Colors.grey;
  } else if (status == "Overdue") {
    return Colors.red;
  } else {
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

String formatDate(String dateString) {
  // Create a DateFormat for the input format
  DateFormat inputFormat = DateFormat("MM/dd/yyyy HH:mm:ss");
  // Parse the date string
  DateTime dateTime = inputFormat.parse(dateString);
  // Format the date to a more readable format
  DateFormat outputFormat = DateFormat("MM-dd-yyyy"); // Change to your desired output format
  return outputFormat.format(dateTime);
}

