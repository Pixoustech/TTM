// lib/constants/app_constants.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../Login_Page/login_page.dart';
import '../MapScreen.dart';
import 'dart:developer' as developer;

class AppColors {
  static const Color concolor = Color(0xFF7E1416);
  static const Color backwhite = Color(0xFFFFFFFF);
}


class AppApi {
  static const String baseUrl = "http://ttm.dev.pixous.info/api";
  static String authToken = AppConstants.token ?? '';

  // Create a Dio instance with base options
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authToken,
      },
    ),
  );

  // Initialize Dio and add an interceptor for token validation
  static void initialize() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Attach the latest token to every request
        options.headers['Authorization'] = authToken;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Process successful responses
        return handler.next(response);
      },
      onError: (DioError error, handler) async {
        if (error.response?.statusCode == 401) {
          // Handle Unauthorized response
          await sessionOut(); // Log out user and redirect to login page
        } else {
          // Handle other errors if necessary
          print("Error occurred: ${error.message}");
        }
        return handler.next(error);
      },
    ));
  }

  // Handle session logout and redirection to the login page
  static Future<void> sessionOut() async {
    final prefs = AppConstants._prefs;
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

    // Clear user session data
    await prefs?.remove('userToken');
    await prefs?.remove('userId');
    await secureStorage.delete(key: 'username'); // Clear username
    await secureStorage.delete(key: 'password'); // Clear password

    // Navigate to the LoginPage
    if (AppConstants.navigatorKey.currentState != null) {
      AppConstants.navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
      );
    }

    // Show a SnackBar to inform the user
    if (AppConstants.scaffoldMessengerKey.currentState != null) {
      AppConstants.scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            "Session expired. Please log in again.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Update and store the token after login
  static Future<void> updateToken(String token) async {
    authToken = token;
    await AppConstants._prefs?.setString('userToken', token);
    dio.options.headers['Authorization'] = authToken; // Update the header with the new token
  }

  // Print the current token for debugging
  static void printAuthToken() {
    print('Current Auth Token: $authToken');
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

  // Keys for storing data in SharedPreferences
  static const String _userIdKey = 'userId';
  static const String _userTokenKey = 'userToken';

  // Navigation and Messenger Keys
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // Initialize SharedPreferences
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getter to retrieve userId
  static String? get userId {
    return _prefs?.getString(_userIdKey);
  }

  // Setter to store userId
  static Future<void> setUserId(String userId) async {
    await _prefs?.setString(_userIdKey, userId);
  }

  // Getter to retrieve userToken
  static String? get token {
    return _prefs?.getString(_userTokenKey);
  }

  // Setter to store userToken
  static Future<void> setToken(String token) async {
    await _prefs?.setString(_userTokenKey, token);
  }

  // Clear all stored preferences (e.g., during logout)
  static Future<void> clearPreferences() async {
    await _prefs?.clear();
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


class LocationRequest {
  // Request location permission
  static Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  // Get the current location
  static Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}



class PermissionUtils {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Method to request notification permission
  static Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      // Handle Android platform using the local notifications plugin
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();
      return grantedNotificationPermission ?? false; // Return true if granted, false otherwise
    } else if (Platform.isIOS) {
      // For iOS, use the permission_handler package to request notification permission
      var status = await requestNotificationPermissions();
      return status.isGranted; // Return true if granted, false otherwise
    }
    return false; // Default to false for unsupported platforms
  }

  // Request notification permissions, used by iOS devices
  static Future<PermissionStatus> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      // Notification permissions granted
      return status;
    } else if (status.isDenied) {
      // Notification permissions denied
      return status;
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied, open app settings
      await openAppSettings();
      return status;
    }
    return status;
  }
}
