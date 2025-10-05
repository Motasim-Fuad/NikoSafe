import 'dart:io';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import '../../Data/Network/Network_api_services.dart';

class AuthRepository {
  final _apiService = NetworkApiServices();

  // ====== REGISTRATION APIs (3 Different) ======

  // USER Registration - JSON only (Raw data)
  Future<dynamic> registerUser(Map<String, dynamic> data) async {
    return await _apiService.postApi(
        data,
        AppUrl.userRegisterUrl,
        requireAuth: false
    );
  }

  // SERVICE PROVIDER Registration - Multipart (Form data with image)
  Future<dynamic> registerServiceProvider({
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    return await _apiService.postMultipartApi(
      url: AppUrl.providerRegisterUrl,
      data: data,
      imageFile: imageFile,
      imageFieldName: "image",
      requireAuth: false,
    );
  }

  // VENDOR/HOSPITALITY Registration - Multipart (Form data with image)
  Future<dynamic> registerVendor({
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    return await _apiService.postMultipartApi(
      url: AppUrl.vendorRegisterUrl,
      data: data,
      imageFile: imageFile,
      imageFieldName: "image",
      requireAuth: false,
    );
  }

  // ====== LOGIN APIs (3 Different) ======

  Future<dynamic> login(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.LoginUrl, requireAuth: false);
  }



  // ====== GET APIs ======

  Future<dynamic> getDesignations() async {
    return await _apiService.getApi(AppUrl.getDesignationsUrl, requireAuth: false);
  }

  Future<dynamic> getVenueTypes() async {
    return await _apiService.getApi(AppUrl.getVenueTypesUrl, requireAuth: false);
  }

  // ====== EMAIL VERIFICATION (Same for all) ======

  Future<dynamic> verifyEmailOtp(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.verifyEmailUrl, requireAuth: false);
  }

  Future<dynamic> resendOtp(Map<String, dynamic> data) async {
    final requestData = {
      ...data,
      "purpose": "verification"
    };
    return await _apiService.postApi(requestData, AppUrl.resendOtpUrl, requireAuth: false);
  }

  Future<dynamic> setPassword(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.setPasswordUrl, requireAuth: false);
  }

  // ====== FORGOT PASSWORD (Same for all) ======

  Future<dynamic> forgotPassword(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.forgotPasswordUrl, requireAuth: false);
  }

  Future<dynamic> verifyPasswordResetOtp(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.verifyPasswordResetOtpUrl, requireAuth: false);
  }

  Future<dynamic> resendPasswordResetOtp(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.resendPasswordResetOtpUrl, requireAuth: false);
  }

  Future<dynamic> confirmPasswordReset(Map<String, dynamic> data) async {
    return await _apiService.postApi(data, AppUrl.confirmPasswordResetUrl, requireAuth: false);
  }
}