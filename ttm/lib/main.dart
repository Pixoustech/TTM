import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'Comman_pages/Constant.dart';
import 'Comman_pages/Splash_Screen.dart';
import 'Connectivity_Check.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConstants.initialize();
  AppApi.initialize();
  Get.put(InternetController(), permanent: true);

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // Your app icon

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp instead of MaterialApp
      debugShowCheckedModeBanner: false,
      title: 'TTM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: AppConstants.navigatorKey, // Set the navigator key
      scaffoldMessengerKey: AppConstants.scaffoldMessengerKey, // Set the scaffold messenger key
      home: SplashScreen(), // Start with the SplashScreen
    );
  }
}