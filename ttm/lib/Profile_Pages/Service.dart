import 'dart:convert';
import 'package:dio/dio.dart';
import '../Comman_pages/Constant.dart';
import 'profile_model.dart';

class ApiService {
  final Dio dio = AppApi.dio; // Use the Dio instance from AppApi

  Future<ProfileModel?> fetchUserProfile(String userId) async {
    try {
      final response = await AppApi.dio.get(
        '/Settings/User_Get',
        queryParameters: {
          'IsActive': true,
          'UserId': userId,
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return ProfileModel.fromJson(response.data['data'][0]);
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

}
