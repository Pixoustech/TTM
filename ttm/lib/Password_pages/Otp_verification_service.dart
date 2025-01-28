
import '../Comman_pages/Constant.dart';
import 'Model.dart';

class OtpVerificationService {
  Future<OtpVerificationResponse> verifyOtp(OtpVerificationRequest request) async {
    try {
      // Send the POST request to the API
      final response = await AppApi.dio.post(
        '/api/Account/ValidateOtp',
        data: request.toJson(),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response data
        return OtpVerificationResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      throw Exception('Error occurred while verifying OTP: $e');
    }
  }
}
