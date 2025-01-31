import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'Comman_pages/Constant.dart';
import 'Comman_pages/Splash_Screen.dart';
import 'Connectivity_Check.dart';

/// Flutter Local Notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Ensure all widgets are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize constants and API
  await AppConstants.initialize();
  AppApi.initialize();

  // Inject the InternetController for connectivity checks
  Get.put(InternetController(), permanent: true);

  // Initialize local notifications
  await initializeNotifications();

  // Run the Flutter application
  runApp(const MyApp());
}

/// Function to initialize notifications
Future<void> initializeNotifications() async {
  // Android-specific initialization settings
  const AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // Replace with your app icon

  // iOS-specific initialization settings
  const DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings(
    requestAlertPermission: true, // Request permission to show alerts
    requestBadgePermission: true, // Request permission to update app badge
    requestSoundPermission: true, // Request permission to play sounds
  );

  // Cross-platform initialization settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: darwinInitializationSettings, // Use DarwinInitializationSettings for iOS
  );

  // Initialize the plugin with the settings
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap (optional)
      if (response.payload != null) {
        debugPrint('Notification payload: ${response.payload}');
      }
    },
  );
}

/// Main Application Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      title: 'TTM', // Application title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define the primary theme color
      ),
      navigatorKey: AppConstants.navigatorKey, // Global navigator key for navigation
      scaffoldMessengerKey: AppConstants.scaffoldMessengerKey, // Global scaffold messenger key
      home: SplashScreen(), // Start with the SplashScreen widget
    );
  }
}