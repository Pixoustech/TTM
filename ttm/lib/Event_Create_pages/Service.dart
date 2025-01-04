import 'dart:convert';
import 'package:dio/dio.dart';
import '../Comman_pages/Constant.dart';
import 'Model.dart';

class EventService {
  final Dio _dio = AppApi.dio;

  // Method to create a task
  Future<bool> createTask(TaskModel task) async {
    try {
      final response = await _dio.post(
        '/Event/Event_Master_SaveUpdate', // Specify the correct endpoint for tasks
        data: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create task: ${response.data}');
        return false;
      }
    } catch (e) {
      _handleError(e);
      return false;
    }
  }


  Future<bool> createMeeting(MeetingModel meeting) async {
    try {
      final response = await _dio.post(
        '//Event/Event_Master_SaveUpdate', // Specify the correct endpoint for meetings
        data: jsonEncode(meeting.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create meeting: ${response.data}');
        return false;
      }
    } catch (e) {
      _handleError(e);
      return false;
    }
  }


  void _handleError(dynamic error) {
    if (error is DioError) {
      print('Dio error: ${error.response?.data ?? error.message}');
    } else {
      print('Unexpected error: $error');
    }
  }
}
