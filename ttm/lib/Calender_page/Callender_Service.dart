import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../Comman_pages/Constant.dart';
import 'model.dart';

class CalendarService {
  final Dio _dio = AppApi.dio;

/*
  Future<CalendarEventData?> fetchCalendarDatas(String userId, DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final String apiUrl = '/Event/Event_Master_Get';

    try {
      final response = await _dio.get(apiUrl, queryParameters: {
        'userId': userId,
        'date': formattedDate,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        if (jsonResponse['data'] != null) {
          return CalendarEventData.fromJson(jsonResponse['data']);
        } else {
          print('No data found for the selected date: $formattedDate');
          return null;
        }
      } else {
        throw Exception('Failed to load calendar data');
      }
    } catch (e) {
      print('Error fetching calendar data: $e');
      return null;
    }
  }
*/

  Future<List<Leave>> fetchLeaveData(String userId) async {
    final String apiUrl = '/Ttm/Leave_Master_Get';

    try {
      final response = await _dio.get(apiUrl, queryParameters: {
        'UserId': userId,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        if (jsonResponse['data'] != null) {
          List<dynamic> leaves = jsonResponse['data'];
          return leaves.map((leave) => Leave.fromJson(leave)).toList();
        } else {
          print('No leave data found.');
          return [];
        }
      } else {
        throw Exception('Failed to load leave data');
      }
    } catch (e) {
      print('Error fetching leave data: $e');
      return [];
    }
  }

  Future<Map<DateTime, String>> fetchHolidayData() async {
    final String apiUrl = '/Ttm/Holiday_Master_Get?IsActive=true';  // Corrected API URL
    Map<DateTime, String> holidays = {};
    print('Token: ${AppConstants.token}');

    try {
      final response = await AppApi.dio.get(apiUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        if (jsonResponse['data'] != null) {
          List<dynamic> holidayList = jsonResponse['data'];
          for (var holiday in holidayList) {
            if (holiday != null && holiday['holidayDate'] != null) {
              String holidayDateString = holiday['holidayDate'];

              // Parse the ISO 8601 date string directly using DateTime.parse
              DateTime holidayDate = DateTime.parse(holidayDateString);

              // Normalize the date if needed (e.g., remove time or adjust for timezone)
              holidays[normalizeDate(holidayDate)] = holiday['holidayName'] ?? 'No holiday Name';
            } else {
              print('Holiday or date is null');
            }
          }
        } else {
          print('No holiday data found.');
        }
      } else {
        throw Exception('Failed to load holiday data');
      }
    } catch (e) {
      print('Error fetching holiday data: $e');
    }

    return holidays;
  }

  Future<CalendarEventResponse?> fetchCalendarData(int month, int year) async {
    try {
      // Construct the full URL using the base URL and query parameters
      final String url = '/Event/User_Calender_Get?Month=$month&Year=$year';
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        if (jsonResponse['status'] == 'SUCCESS') {
          // Use the CalendarEventResponse to parse the response
          return CalendarEventResponse.fromJson(jsonResponse);
        } else {
          print('Error fetching data: ${jsonResponse['message']}');
          return null;
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }


  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
