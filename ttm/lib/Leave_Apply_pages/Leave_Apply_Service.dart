// leave_application_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../Comman_pages/Constant.dart';
import 'Leaev_Apply_Model.dart';

class LeaveApplicationService {
  final Dio _dio = AppApi.dio;


  Future<Map<String, dynamic>> applyLeave(LeaveApplication leaveApplication) async {
    try {
      final response = await _dio.post(
        '/Ttm/Leave_Master_SaveUpdate', // Endpoint relative to the base URL
        data: leaveApplication.toJson(),
      );

      return response.data; // Assuming the response is already in JSON format
    } on DioError catch (e) {
      // Handle Dio errors
      throw Exception('Failed to apply leave: ${e.response?.data ?? e.message}');
    }
  }
}

class LeaveApplicationServiceDropdown {
  final String apiUrl = '//Settings/ConfigurationSelectList_Get?ConfigurationId=&CategoryId=&ParentConfigurationId=&IsActive=true&CategoryCode=LEAVE_TYPE'; // Base URL should be handled by AppApi
  final Dio dio = AppApi.dio; // Initialize Dio instance from AppApi

  // Fetch the leave types from the API
  Future<List<LeaveTypeModel>> fetchLeaveTypes() async {
    try {
      // Make a GET request to the API using Dio
      final response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        // Check if the response is a map and contains the 'data' key
        if (response.data is Map<String, dynamic> && response.data['data'] is List) {
          // Extract the list of leave types
          List<dynamic> data = response.data['data'];

          // Map the data into a list of LeaveTypeModel
          return data.map((e) => LeaveTypeModel.fromJson(e)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load leave types');
      }
    } catch (e) {
      // Handle any errors that occur during the API request
      throw Exception('Error: $e');
    }
  }

}
