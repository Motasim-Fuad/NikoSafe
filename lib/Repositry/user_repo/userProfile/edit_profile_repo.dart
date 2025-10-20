// Repository/user_profile_repository.dart
import 'dart:io';
import 'package:nikosafe/data/network/network_api_services.dart';
import 'package:nikosafe/models/User/myProfileModel/my_profile_edit_model.dart' show MyProfileEditModel;
import 'package:nikosafe/resource/App_Url/app_url.dart';

class EditUserProfileRepository {
  final _apiServices = NetworkApiServices();

  // Get user profile
  Future<MyProfileEditModel> getUserProfile() async {
    try {
      final response = await _apiServices.getApi(
        AppUrl.myProfile,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return MyProfileEditModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile (with image)
  Future<MyProfileEditModel> updateUserProfile({
    required Map<String, dynamic> data,
    File? profileImage,
  }) async {
    try {
      dynamic response;

      if (profileImage != null) {
        // Use multipart if image is present
        response = await _apiServices.putMultipartApi(
          url: AppUrl.myProfile,
          data: data,
          imageFile: profileImage,
          imageFieldName: 'profile_picture',
          requireAuth: true,
        );
      } else {
        // Use regular PUT if no image
        response = await _apiServices.putApi(
          data,
          AppUrl.myProfile,
          requireAuth: true,
        );
      }

      if (response['success'] == true) {
        return MyProfileEditModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      rethrow;
    }
  }
}