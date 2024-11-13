import 'package:dio/dio.dart';
import '../Comman_pages/Constant.dart';
import 'model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppApi.baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  ApiService() {
    // Add an interceptor for logging
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.path}');
        print('Request Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        print('Error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'username': username, 'password': password},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
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