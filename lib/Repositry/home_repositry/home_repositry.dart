// repository/home_repository.dart
import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/models/userHome/postType_model.dart';
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
}