// Path: View_Model/Controller/user/userHome/profileDetailsController.dart
// Create this NEW file

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userHome_repo/feed_repository.dart';
import '../../../../models/User/userHome/post_model.dart';
import '../../../../utils/utils.dart';

class ProfileDetailsController extends GetxController {
  final FeedRepository _repository = FeedRepository();

  RxList<Data> userPosts = <Data>[].obs;
  RxBool isLoading = false.obs;

  // Load specific user posts by filtering from feed
  Future<void> loadUserPosts(List<int> postIds) async {
    if (postIds.isEmpty) {
      userPosts.value = [];
      if (kDebugMode) {
        print("No post IDs provided for this user");
      }
      return;
    }

    try {
      isLoading.value = true;

      if (kDebugMode) {
        print("Loading posts for IDs: $postIds");
      }

      // Fetch all posts from feed
      final response = await _repository.fetchFeedPosts();

      if (response['success'] == true) {
        final List<dynamic> postsData = response['data']['posts'] ?? [];

        if (kDebugMode) {
          print("Total posts from API: ${postsData.length}");
        }

        // Convert to Data objects
        List<Data> allPosts = postsData.map((json) => Data.fromJson(json)).toList();

        // Filter posts that match the user's post IDs
        userPosts.value = allPosts.where((post) {
          final matches = postIds.contains(post.id);
          if (kDebugMode && matches) {
            print("Found matching post: ${post.id}");
          }
          return matches;
        }).toList();

        if (kDebugMode) {
          print("User posts loaded: ${userPosts.length} out of ${postIds.length}");
          if (userPosts.isEmpty) {
            print("WARNING: No matching posts found in feed API");
            print("Requested post IDs: $postIds");
            print("Available post IDs in feed: ${allPosts.map((p) => p.id).toList()}");
          }
        }
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to load posts');
        if (kDebugMode) {
          print("Load user posts error: ${response['message']}");
        }
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      if (kDebugMode) {
        print("Error fetching user posts: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh user posts
  Future<void> refreshUserPosts(List<int> postIds) async {
    await loadUserPosts(postIds);
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}