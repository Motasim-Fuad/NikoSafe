// AuthRepository.dart
import 'dart:io';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import '../../Data/Network/Network_api_services.dart';

class AuthRepository {
  final _apiService = NetworkApiServices(); // Fixed: _ instead of *

  // ✅ User Registration - JSON only (No token needed)
  Future<dynamic> registerUserJson(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.userRegisterUrl, requireAuth: false);
  }

  // ✅ For SERVICE_PROVIDER & HOSPITALITY_VENUE role (Image + Multipart) (No token needed)
  Future<dynamic> registerUserMultipart({
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    return await _apiService.postMultipartApi(
      url: AppUrl.userRegisterUrl,
      data: data,
      imageFile: imageFile,
      imageFieldName: "image",
      requireAuth: false, // No token needed for registration
    );
  }

  // ✅ Email OTP Verification (No token needed)
  Future<dynamic> verifyEmailOtp(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.verifyEmailUrl, requireAuth: false);
  }

  // ✅ Resend OTP (No token needed)
  Future<dynamic> resendOtp(Map<String, dynamic> data) async {
    // Add purpose field as required by your API
    final requestData = {
      ...data,
      "purpose": "verification"
    };
    return await _apiService.postApi(requestData, AppUrl.resendOtpUrl, requireAuth: false);
  }

  // ✅ Set Password API (No token needed)
  Future<dynamic> setPassword(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.setPasswordUrl, requireAuth: false);
  }

  // ✅ User Login API (No token needed)
  Future<dynamic> loginUser(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.loginUrl, requireAuth: false);
  }

  // ✅ Forgot Password API (No token needed)
  Future<dynamic> forgotPassword(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.forgotPasswordUrl, requireAuth: false);
  }

  // ✅ Verify Password Reset OTP (No token needed)
  Future<dynamic> verifyPasswordResetOtp(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.verifyPasswordResetOtpUrl, requireAuth: false);
  }

  // ✅ Resend Password Reset OTP (No token needed)
  Future<dynamic> resendPasswordResetOtp(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.resendPasswordResetOtpUrl, requireAuth: false);
  }

  // ✅ Confirm Password Reset - Set New Password (No token needed)
  Future<dynamic> confirmPasswordReset(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.confirmPasswordResetUrl, requireAuth: false);
  }
}