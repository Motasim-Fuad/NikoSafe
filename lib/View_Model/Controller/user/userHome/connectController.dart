// Path: View_Model/Controller/user/userHome/connectController.dart
// Copy this ENTIRE file

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userHome_repo/connect_user_repo.dart';
import 'package:nikosafe/models/User/userHome/connect_user_model.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/utils/utils.dart';


class ConnectController extends GetxController {
  final userRepo = ConnectUserRepo();

  RxList<ConnectUser> allConnections = <ConnectUser>[].obs;
  RxList<ConnectUser> filteredConnections = <ConnectUser>[].obs;
  RxString searchText = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;

  RxInt currentPage = 1.obs;
  RxBool hasMore = true.obs;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    loadAllUsers();
    searchText.listen((text) {
      if (text.isEmpty) {
        filteredConnections.value = allConnections
            .where((user) => user.friendshipStatus != 'accepted')
            .toList();
      } else {
        searchUsers();
      }
    });
  }

  Future<void> loadAllUsers() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;

      final response = await userRepo.searchUsers(
        search: '',
        page: currentPage.value,
        pageSize: pageSize,
      );

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> usersJson = response['data']['users'] ?? [];

        allConnections.value = usersJson
            .map((json) => ConnectUser.fromJson(json))
            .where((user) => user.friendshipStatus != 'accepted')
            .toList();

        filteredConnections.value = allConnections;
        hasMore.value = usersJson.length >= pageSize;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading users: $e');
      }
      Utils.errorSnackBar('Error', 'Failed to load users');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String text) {
    searchText.value = text.trim();
    currentPage.value = 1;
    hasMore.value = true;
  }

  Future<void> searchUsers() async {
    final query = searchText.value.trim();

    if (query.isEmpty) {
      filteredConnections.value = allConnections
          .where((user) => user.friendshipStatus != 'accepted')
          .toList();
      return;
    }

    if (query.length < 2) {
      return;
    }

    try {
      isSearching.value = true;

      final response = await userRepo.searchUsers(
        search: query,
        page: currentPage.value,
        pageSize: pageSize,
      );

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> usersJson = response['data']['users'] ?? [];

        List<ConnectUser> searchResults = usersJson
            .map((json) => ConnectUser.fromJson(json))
            .where((user) => user.friendshipStatus != 'accepted')
            .toList();

        if (currentPage.value == 1) {
          allConnections.value = searchResults;
        } else {
          allConnections.addAll(searchResults);
        }

        filteredConnections.value = allConnections;
        hasMore.value = usersJson.length >= pageSize;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error searching users: $e');
      }
      Utils.errorSnackBar('Error', 'Failed to search users');
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> loadMoreUsers() async {
    if (isSearching.value || !hasMore.value) return;

    currentPage.value++;

    if (searchText.value.isEmpty) {
      await loadAllUsers();
    } else {
      await searchUsers();
    }
  }

  Future<void> sendFriendRequest(int userId, String userName) async {
    try {
      isLoading.value = true;

      final response = await userRepo.sendFriendRequest(userId);

      if (response['success'] == true) {
        Utils.infoSnackBar('Success', response['message'] ?? 'Friend request sent to $userName');

        int index = allConnections.indexWhere((user) => user.id == userId);
        if (index != -1) {
          allConnections[index] = ConnectUser(
            id: allConnections[index].id,
            email: allConnections[index].email,
            name: allConnections[index].name,
            profilePicture: allConnections[index].profilePicture,
            friendshipStatus: 'pending',
            totalFriends: allConnections[index].totalFriends,
            totalPosts: allConnections[index].totalPosts,
            postIds: allConnections[index].postIds,
            points: allConnections[index].points,
            connectPercentage: allConnections[index].connectPercentage,
          );
          // Update both lists and force refresh
          filteredConnections.value = allConnections
              .where((user) => user.friendshipStatus != 'accepted')
              .toList();
          allConnections.refresh();
          filteredConnections.refresh();
        }
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to send friend request');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending friend request: $e');
      }
      Utils.errorSnackBar('Error', 'Failed to send friend request');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> sendFriendRequest(int userId, String userName) async {
  //   try {
  //     isLoading.value = true;
  //
  //     final response = await userRepo.sendFriendRequest(userId);
  //
  //     if (response['success'] == true) {
  //       Utils.infoSnackBar('Success', response['message'] ?? 'Friend request sent to $userName');
  //
  //       int index = allConnections.indexWhere((user) => user.id == userId);
  //       if (index != -1) {
  //         allConnections[index] = ConnectUser(
  //           id: allConnections[index].id,
  //           email: allConnections[index].email,
  //           name: allConnections[index].name,
  //           profilePicture: allConnections[index].profilePicture,
  //           friendshipStatus: 'pending',
  //           totalFriends: allConnections[index].totalFriends,
  //           totalPosts: allConnections[index].totalPosts,
  //           postIds: allConnections[index].postIds,
  //           points: allConnections[index].points,
  //           connectPercentage: allConnections[index].connectPercentage,
  //         );
  //         filteredConnections.value = allConnections;
  //         filteredConnections.refresh();
  //       }
  //     } else {
  //       Utils.errorSnackBar('Error', response['message'] ?? 'Failed to send friend request');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error sending friend request: $e');
  //     }
  //     Utils.errorSnackBar('Error', 'Failed to send friend request');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void removeAcceptedUser(int userId) {
    allConnections.removeWhere((user) => user.id == userId);
    filteredConnections.value = allConnections;
  }

  void goToProfile(ConnectUser user) {
    Get.toNamed(RouteName.profileDetailsPage, arguments: user);
  }

  String getConnectionButtonText(String friendshipStatus) {
    switch (friendshipStatus) {
      case 'accepted':
        return 'Friends';
      case 'pending':
        return 'Pending';
      case 'declined':
      case 'not_connected':
      default:
        return 'Connect';
    }
  }

  bool isConnectionButtonEnabled(String friendshipStatus) {
    return friendshipStatus == 'not_connected' || friendshipStatus == 'declined';
  }

  Future<void> refreshList() async {
    searchText.value = '';
    await loadAllUsers();
  }
}