// Path: View_Model/Controller/user/MyProfile/my_profile_details_controller/connectController.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userHome_repo/connect_user_repo.dart';
import 'package:nikosafe/models/User/userHome/connect_user_model.dart';
import 'package:nikosafe/utils/token_manager.dart'; // ✅ Import this
import 'package:nikosafe/utils/utils.dart';


class ConnectsController extends GetxController {
  final userRepo = ConnectUserRepo();

  RxList<ConnectUser> connects = <ConnectUser>[].obs;
  RxBool isLoading = false.obs;
  int? currentUserId;

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserId();
  }

  // ✅ Get current user ID first
  Future<void> _getCurrentUserId() async {
    currentUserId = await TokenManager.getUserId();
    if (kDebugMode) print('Current user ID: $currentUserId');
    await loadAcceptedFriends();
  }

  // Load only accepted friends
  Future<void> loadAcceptedFriends() async {
    // ✅ Wait for user ID if not loaded yet
    if (currentUserId == null) {
      currentUserId = await TokenManager.getUserId();
    }

    if (currentUserId == null) {
      if (kDebugMode) print('❌ Cannot load friends: No user ID');
      return;
    }

    try {
      isLoading.value = true;

      final response = await userRepo.getUserFriends();

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> friendshipsJson = response['data'] as List;

        List<ConnectUser> acceptedFriends = [];

        for (var friendship in friendshipsJson) {
          // Only process accepted friendships
          if (friendship['status'] != 'accepted') continue;

          final requester = friendship['requester'];
          final receiver = friendship['receiver'];

          // ✅ Determine which one is the friend (not current user)
          Map<String, dynamic> friendUser;

          if (requester['id'] == currentUserId) {
            // Current user is requester, so friend is receiver
            friendUser = receiver;
          } else {
            // Current user is receiver, so friend is requester
            friendUser = requester;
          }

          // ✅ Convert to ConnectUser format
          final friendData = {
            'id': friendUser['id'],
            'email': friendUser['email'],
            'name': '${friendUser['first_name'] ?? ''} ${friendUser['last_name'] ?? ''}'.trim().isEmpty
                ? friendUser['email'].split('@')[0]
                : '${friendUser['first_name'] ?? ''} ${friendUser['last_name'] ?? ''}'.trim(),
            'profile_picture': friendUser['profile_picture'],
            'friendship_status': 'accepted',
            'total_friends': friendUser['total_friends'] ?? 0,
            'total_posts': friendUser['total_posts'] ?? 0,
            'post_ids': friendUser['post_ids'] ?? [],
            'points': friendUser['points'] ?? 0,
            'connect_percentage': friendUser['connect_percentage'] ?? 0,
          };

          acceptedFriends.add(ConnectUser.fromJson(friendData));
        }

        connects.value = acceptedFriends;

        if (kDebugMode) {
          print("✅ Accepted friends loaded: ${connects.length}");
          for (var friend in acceptedFriends) {
            print("  - ${friend.name} (ID: ${friend.id})");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading accepted friends: $e');
      }
      Utils.errorSnackBar('Error', 'Failed to load friends');
    } finally {
      isLoading.value = false;
    }
  }

  // Remove friend
  Future<void> removeConnect(int index) async {
    if (index < 0 || index >= connects.length) return;

    final friend = connects[index];

    try {
      // Show confirmation dialog
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: Color(0xFF37424A),
          title: Text('Remove Friend', style: TextStyle(color: Colors.white)),
          content: Text(
            'Are you sure you want to remove ${friend.name} from your friends?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      // Remove from UI first (optimistic)
      connects.removeAt(index);

      // TODO: Add API call to remove friend
      // final response = await userRepo.removeFriend(friend.id);

      Utils.successSnackBar('Success', '${friend.name} removed from friends');
    } catch (e) {
      if (kDebugMode) {
        print('Error removing friend: $e');
      }
      Utils.errorSnackBar('Error', 'Failed to remove friend');
      // Reload list on error
      loadAcceptedFriends();
    }
  }

  Future<void> refreshFriends() async {
    await loadAcceptedFriends();
  }
}