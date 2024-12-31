
import '../Comman_pages/Constant.dart';
import 'Model.dart';


class OtpService {
  // Method to send OTP
  Future<OtpResponseModel> sendOtp(String mobileNumber) async {
    try {
      // Send GET request using the AppApi's Dio instance
      final response = await AppApi.dio.get(
        '/Account/SendOtp',
        queryParameters: {'MobileNumber': mobileNumber},
      );

      // Check for a successful response
      if (response.statusCode == 200) {
        return OtpResponseModel.fromJson(response.data);
      } else {
        return OtpResponseModel(
          success: false,
          message: "Server error: ${response.statusCode}",
        );
      }
    } catch (e) {
      return OtpResponseModel(
        success: false,
        message: "An error occurred: $e",
      );
    }
  }
}