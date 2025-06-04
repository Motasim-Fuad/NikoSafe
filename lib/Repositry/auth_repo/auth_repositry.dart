// ✅ REPOSITORY: auth_repository.dart
import 'dart:io';

import 'package:nikosafe/resource/App_Url/app_url.dart';

import '../../Data/Network/Network_api_services.dart';


class AuthRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> login(Map data) async {
    return await _apiService.postApi(data, AppUrl.loginApi);
  }

  Future<dynamic> signupWithImage({
    required Map<String, String> data,
    File? imageFile,
  }) async {
    return await _apiService.postMultipartApi(
      url: AppUrl.userRegisterUrl,
      fields: data,
      imageFile: imageFile,
      imageFieldName: "image",
    );
  }


  Future<dynamic> signup(Map data) async {
    return await _apiService.postApi(data, AppUrl.userRegisterUrl);
  }
}
