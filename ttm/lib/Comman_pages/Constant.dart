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
  static const String baseurl = "http://ttm.dev.pixous.info/api";
  static String authToken = AppConstants.token ?? '';
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseurl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$authToken',
      },
    ),
  );

  // Method to store the token
  static Future<void> storeToken(String token) async {
    authToken = token; // Update the local variable
    AppConstants._prefs?.setString('userToken', token); // Store in SharedPreferences
    dio.options.headers['Authorization'] = '$authToken'; // Update Dio headers
  }

  // Method to refresh the token
  static Future<void> refreshToken(String token) async {
    authToken = token;
    try {
      final response = await dio.post('/auth/refresh', data: {
        'refreshToken': authToken, // Assuming you have a refresh token
      });

      if (response.statusCode == 200) {
        String newToken = response.data['accessToken'];
        await storeToken(newToken); // Store the new token
      } else {
        print('Failed to refresh token: ${response.statusCode}');
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
  }
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
  static String? get token {
    return _prefs?.getString('userToken');
  }
}


class DialogUtils {
  static void showSuccessDialog(BuildContext context, String message, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (onOk != null) {
                  onOk(); // Call the callback if provided
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
  try {
    // Use the appropriate format for parsing
    DateFormat inputFormat = DateFormat("yyyy-MM-dd");
    DateTime dateTime = inputFormat.parse(dateString);

    // Define the desired output format
    DateFormat outputFormat = DateFormat("MM-dd-yyyy"); // Customize as needed
    return outputFormat.format(dateTime);
  } catch (e) {
    print('Error parsing date: $dateString - $e');
    return "Invalid Date";
  }
}


