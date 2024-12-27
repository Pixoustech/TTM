import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../Comman_pages/Constant.dart';
import 'model.dart';

class CalendarService {
  final Dio _dio = AppApi.dio;

  Future<CalendarEventData?> fetchCalendarData(String userId, DateTime date) async {
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

  Future<List<Leave>> fetchLeaveData(String userId) async {
    final String apiUrl = '/Ttm/Leave_Master_Get';

    try {
      final response = await _dio.get(apiUrl, queryParameters: {
        'User Id': userId,
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
    final String apiUrl = '/Ttm/Holiday_Master/Get';
    Map<DateTime, String> holidays = {};

    try {
      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        if (jsonResponse['data'] != null) {
          List<dynamic> holidayList = jsonResponse['data'];
          for (var holiday in holidayList) {
            if (holiday != null && holiday['date'] != null) {
              String holidayDateString = holiday['date'];
              DateFormat format = DateFormat("MM/dd/yyyy HH:mm:ss");
              DateTime holidayDate = format.parse(holidayDateString);
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

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
