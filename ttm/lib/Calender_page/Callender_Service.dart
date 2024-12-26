import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'model.dart';


class LeaveService {
  final String baseUrl = 'https://1e7e-2405-201-e02b-58e4-ad03-6224-7716-c5b5.ngrok-free.app/api/Ttm/Leave_Master_Get?UserId=';

  // Update the function to accept userId and selectedDate
  Future<List<Leave>> fetchLeaves(String userId, DateTime selectedDate) async {

    // Ensure the URL is correct, and you are passing parameters
    final response = await http.get(Uri.parse('$baseUrl?UserId=$userId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'SUCCESS') {
        List<dynamic> data = jsonResponse['data'];
        return data.map((leave) => Leave.fromJson(leave)).toList();
      } else {
        throw Exception('Failed to load leaves');
      }
    } else {
      throw Exception('Failed to load leaves');
    }
  }
}
class HolidayService {
  final String apiUrl = 'https://7a77-2405-201-e02b-58e4-ad03-6224-7716-c5b5.ngrok-free.app/api/Ttm/Holiday_Master/Get'; // Your holiday API URL

  Future<List<Holiday>> fetchHolidays() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          List<dynamic> holidaysJson = jsonResponse['data'];
          return holidaysJson.map((holiday) => Holiday.fromJson(holiday)).toList();
        } else {
          return []; // Return an empty list if no data found
        }
      }
      else {
        throw Exception('Failed to load holidays');
      }
    } catch (e) {
      print('Error fetching holidays: $e');
      return []; // Return an empty list on error
    }
  }
}