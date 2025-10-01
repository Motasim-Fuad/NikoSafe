// Path: View_Model/Controller/user/MyProfile/my_profile_details_controller/connectController.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/userHome_repo/connect_user_repo.dart';
import 'package:nikosafe/models/userHome/connect_user_model.dart';
import 'package:nikosafe/utils/utils.dart';


class ConnectsController extends GetxController {
  final userRepo = ConnectUserRepo();

  RxList<ConnectUser> connects = <ConnectUser>[].obs;
  RxBool isLoading = false.obs;
  int? currentUserId;

  @override
  void onInit() {
    super.onInit();
    loadAcceptedFriends();
  }

  // Load only accepted friends
  Future<void> loadAcceptedFriends() async {
    try {
      isLoading.value = true;

      final response = await userRepo.getUserFriends();

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> friendshipsJson = response['data'] as List;

        List<ConnectUser> acceptedFriends = [];

        for (var friendship in friendshipsJson) {
          // Only process accepted friendships
          if (friendship['status'] != 'accepted') continue;

          // Get the friend user (not the current user)
          Map<String, dynamic> friendData;

          // You need to determine which user is the friend
          // Assuming current user is the one making the request
          // You might need to get current user ID from storage/auth
          final requester = friendship['requester'];
          final receiver = friendship['receiver'];

          // For now, we'll include both users (you can filter by current user ID later)
          // Convert to ConnectUser format
          friendData = {
            'id': receiver['id'],
            'email': receiver['email'],
            'name': '${receiver['first_name']} ${receiver['last_name']}'.trim().isEmpty
                ? receiver['email'].split('@')[0]
                : '${receiver['first_name']} ${receiver['last_name']}'.trim(),
            'profile_picture': null,
            'friendship_status': 'accepted',
            'total_friends': 0,
            'total_posts': 0,
            'post_ids': [],
            'points': 0,
            'connect_percentage': 0,
          };

          acceptedFriends.add(ConnectUser.fromJson(friendData));
        }

        connects.value = acceptedFriends;

        if (kDebugMode) {
          print("Accepted friends loaded: ${connects.length}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading accepted friends: $e');
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