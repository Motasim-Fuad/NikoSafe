// Repositry/user_repo/userProfile/user_my_profile_details.dart

import 'package:nikosafe/data/Network/network_api_services.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import 'package:nikosafe/utils/token_manager.dart';

class MyProfileRepository {
  final _apiService = NetworkApiServices();

  // Get current user's profile
  Future<Map<String, dynamic>> getProfileData() async {
    try {

      final response = await _apiService.getApi(
        AppUrl.myProfile,
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      print('❌ Profile fetch error: $e');
      rethrow;
    }
  }

}