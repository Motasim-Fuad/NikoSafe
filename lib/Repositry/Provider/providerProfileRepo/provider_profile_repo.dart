import 'dart:io';
import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class ProviderProfileRepo {
  final _apiService = NetworkApiServices();

  Future<dynamic> fetchProfile() async {
    try {
      final response = await _apiService.getApi(
        AppUrl.providerProfileUrl,
        requireAuth: true,
      );
      return response;
    } catch (e) {
      print("❌ Repo fetchProfile error: $e");
      rethrow;
    }
  }

  // ✅ FIX: Use PUT for both text and image
  Future<dynamic> updateProfile(Map<String, dynamic> data, File? image) async {
    try {
      if (image != null) {
        print("📸 Uploading with image using PUT multipart...");
        // Use PUT multipart (need to modify NetworkApiServices)
        return await _apiService.putMultipartApi(
          url: AppUrl.providerProfileUrl,
          data: data,
          imageFile: image,
          imageFieldName: "profile_picture",
          requireAuth: true,
        );
      } else {
        print("📝 Updating without image (PUT)...");
        return await _apiService.putApi(
          data,
          AppUrl.providerProfileUrl,
          requireAuth: true,
        );
      }
    } catch (e) {
      print("❌ Repo updateProfile error: $e");
      rethrow;
    }
  }
}