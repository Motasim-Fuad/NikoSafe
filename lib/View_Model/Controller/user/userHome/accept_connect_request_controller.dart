// Path: View_Model/Controller/user/userHome/accept_connect_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userHome_repo/connect_user_repo.dart';
import 'package:nikosafe/models/User/userHome/connect_user_model.dart';

import '../../../../resource/App_routes/routes_name.dart';
import '../../../../utils/utils.dart';

class AcceptConnectController extends GetxController {
  final ConnectUserRepo userRepo = ConnectUserRepo();

  RxList<ConnectUser> friendRequests = <ConnectUser>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFriendRequests();
  }

  Future<void> loadFriendRequests() async {
    try {
      isLoading.value = true;

      final response = await userRepo.getUserFriends();

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> friendsData = response['data'] ?? [];

        if (kDebugMode) {
          print('Friend requests data: $friendsData');
        }

        // Filter only pending friend requests where current user is the receiver
        friendRequests.value = friendsData
            .where((item) {
          // Check if status is 'pending' and current user is receiver
          final status = item['status']?.toString().toLowerCase();
          final receiver = item['receiver'];

          // The current user should be in the receiver field for incoming requests
          return status == 'pending' && receiver != null;
        })
            .map((item) {
          // Extract requester information (the person who sent the request)
          final requester = item['requester'];

          if (requester != null) {
            return ConnectUser(
              id: item['id'] ?? 0, // This is the friendship request ID
              email: requester['email'] ?? '',
              name: requester['username'] ?? requester['first_name'] ?? requester['last_name'] ?? 'Unknown',
              profilePicture: requester['profile_picture'],
              friendshipStatus: 'pending',
              totalFriends: 0,
              totalPosts: 0,
              postIds: [],
              points: 0,
              connectPercentage: 0,
            );
          }
          return null;
        })
            .whereType<ConnectUser>()
            .toList();

        if (kDebugMode) {
          print('Loaded ${friendRequests.length} pending friend requests');
        }
      } else {
        if (kDebugMode) {
          print('Failed to load friend requests: ${response['message']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading friend requests: $e');
      }
      Utils.errorSnackBar('Error', 'Failed to load friend requests');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptFriendRequest(int requestId, String userName) async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        barrierDismissible: false,
      );

      final response = await userRepo.acceptFriendRequest(requestId);

      // Close loading dialog
      Get.back();

      if (response['success'] == true) {
        Utils.successSnackBar(
          'Success',
          response['message'] ?? 'You are now friends with $userName',
        );

        // Remove the accepted request from the list
        friendRequests.removeWhere((request) => request.id == requestId);
        friendRequests.refresh();

        if (kDebugMode) {
          print('Friend request accepted: $requestId');
        }
      } else {
        Utils.errorSnackBar(
          'Error',
          response['message'] ?? 'Failed to accept friend request',
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (kDebugMode) {
        print('Error accepting friend request: $e');
      }
      Utils.errorSnackBar('Error', 'Failed to accept friend request');
    }
  }

  Future<void> declineFriendRequest(int requestId, String userName) async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        barrierDismissible: false,
      );

      final response = await userRepo.declineFriendRequest(requestId);

      // Close loading dialog
      Get.back();

      if (response['success'] == true) {
        Utils.infoSnackBar(
          'Ignored',
          response['message'] ?? 'Friend request from $userName declined',
        );

        // Remove the declined request from the list
        friendRequests.removeWhere((request) => request.id == requestId);
        friendRequests.refresh();

        if (kDebugMode) {
          print('Friend request declined: $requestId');
        }
      } else {
        Utils.errorSnackBar(
          'Error',
          response['message'] ?? 'Failed to decline friend request',
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (kDebugMode) {
        print('Error declining friend request: $e');
      }
      Utils.errorSnackBar('Error', 'Failed to decline friend request');
    }
  }

  void viewProfile(ConnectUser user) {
    // Navigate to profile details page
    Get.toNamed(RouteName.profileDetailsPage, arguments: user);
  }

  Future<void> refreshRequests() async {
    await loadFriendRequests();
  }

  @override
  void onClose() {
    super.onClose();
  }
}