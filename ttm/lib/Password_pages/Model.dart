class OtpResponseModel {
  final bool success;
  final String message;
  final String? data;

  OtpResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      success: json['status'] == "SUCCESS",
      message: json['message'] ?? "",
      data: json['data'],
    );
  }
}
class OtpVerificationRequest {
  final String mobileNumber;
  final String otp;

  OtpVerificationRequest({required this.mobileNumber, required this.otp});

  // Convert request to JSON format
  Map<String, dynamic> toJson() {
    return {
      'mobileNumber': mobileNumber,
      'otp': otp,
    };
  }
}

class OtpVerificationResponse {
  final String status;
  final String message;

  OtpVerificationResponse({required this.status, required this.message});

  // Create a response object from JSON
  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
