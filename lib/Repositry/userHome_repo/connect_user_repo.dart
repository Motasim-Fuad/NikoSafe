// Path: Repositry/userHome_repo/connect_user_repo.dart
// Copy this ENTIRE file

import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import '../../models/userHome/connect_user_model.dart';

class ConnectUserRepo {
  final _apiService = NetworkApiServices();

  Future<Map<String, dynamic>> searchUsers({
    required String search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final url = '${AppUrl.socialSearchUsers}?search=$search&page=$page&page_size=$pageSize';

      final response = await _apiService.getApi(url, requireAuth: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ConnectUser> getUserProfile(int userId) async {
    try {
      final url = AppUrl.getUserProfileUrl(userId);
      final response = await _apiService.getApi(url, requireAuth: true);

      if (response['success'] == true && response['data'] != null) {
        return ConnectUser.fromJson(response['data']);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendFriendRequest(int receiverId) async {
    try {
      final response = await _apiService.postApi(
        {'receiver_id': receiverId},
        AppUrl.socialMakeFriends,
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserFriends() async {
    try {
      final response = await _apiService.getApi(
        AppUrl.socialUserFriends,
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> acceptFriendRequest(int requestId) async {
    try {
      final url = AppUrl.getAcceptFriendRequestUrl(requestId);
      final response = await _apiService.postApi({}, url, requireAuth: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> declineFriendRequest(int requestId) async {
    try {
      final url = AppUrl.getDeclineFriendRequestUrl(requestId);
      final response = await _apiService.postApi({}, url, requireAuth: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}