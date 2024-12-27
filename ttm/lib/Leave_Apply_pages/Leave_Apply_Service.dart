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