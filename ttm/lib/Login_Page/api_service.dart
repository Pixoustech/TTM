import 'package:dio/dio.dart';
import '../Comman_pages/Constant.dart';
import 'model.dart';


class ApiService {
  final Dio _dio = AppApi.dio;

  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/Account/Login',
        data: {'username': username, 'password': password,'device':''},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'SUCCESS') {
        // Successful login and status is true
        return UserModel.fromJson(response.data['data']);
      } else {
        // Login failed or status is false
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      // Log the error for debugging
      print('Login error: $e');
      throw Exception('Login error: $e');
    }
  }
}