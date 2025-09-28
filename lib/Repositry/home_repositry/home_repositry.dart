// repository/home_repository.dart
import 'dart:io';

import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/models/userCreatePost/user_create_post_model.dart';

import 'package:nikosafe/models/userHome/postType_model.dart';
import 'package:nikosafe/models/userHome/privacy_options_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class HomeRepositry{
  final _apiService = NetworkApiServices();
  Future<PostTypesResponse> getPostTypes() async {
    try {
      final response = await _apiService.getApi(
          AppUrl.socialPostTypes,
          requireAuth: true  // This will add Bearer token
      );
      return PostTypesResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<PrivacyOptionsResponse> getPrivacyOptions() async {
    try {
      final response = await _apiService.getApi(
          AppUrl.socialPrivacyOptions,
          requireAuth: true
      );
      return PrivacyOptionsResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }


}