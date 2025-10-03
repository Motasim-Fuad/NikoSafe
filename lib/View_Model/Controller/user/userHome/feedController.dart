// ViewModel/Controller/user/userHome/feedController.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userHome_repo/feed_repository.dart';
import 'package:nikosafe/utils/utils.dart';

import '../../../../models/User/userHome/post_model.dart';

class FeedController extends GetxController {
  final FeedRepository _repository = FeedRepository();

  RxList<Data> posts = <Data>[].obs;
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;
  var showHealthCard = true.obs;

  // For reaction popup
  RxInt selectedPostIdForReaction = 0.obs;
  RxBool showReactionPicker = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  // Load Posts from API
  Future<void> loadPosts() async {
    try {
      isLoading.value = true;
      final response = await _repository.fetchFeedPosts();

      if (response['success'] == true) {
        final List<dynamic> postsData = response['data']['posts'] ?? [];
        posts.value = postsData.map((json) => Data.fromJson(json)).toList();
        print("------------------------------my posts count = ${posts.length}");
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to load posts');
        print("load feed error : ${response['message']}");
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      print("error feed fetch ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh Posts
  Future<void> refreshPosts() async {
    try {
      isRefreshing.value = true;
      final response = await _repository.fetchFeedPosts();

      if (response['success'] == true) {
        final List<dynamic> postsData = response['data']['posts'] ?? [];
        posts.value = postsData.map((json) => Data.fromJson(json)).toList();
        Utils.successSnackBar('Success', 'Feed refreshed');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      print("refresh error: $e");
    } finally {
      isRefreshing.value = false;
    }
  }

  // Add or Update Reaction
  Future<void> toggleReaction(int? postId, String reactionType) async {
    if (postId == null) return;

    try {
      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return;

      final currentPost = posts[postIndex];
      final hadReaction = currentPost.userReaction != null;

      // Safely get reaction type from userReaction (can be String or Map)
      String? currentReactionType;
      if (currentPost.userReaction != null) {
        if (currentPost.userReaction is Map<String, dynamic>) {
          currentReactionType = (currentPost.userReaction as Map<String, dynamic>)['type'] as String?;
        } else if (currentPost.userReaction is String) {
          currentReactionType = currentPost.userReaction as String;
        }
      }

      final sameReaction = hadReaction && currentReactionType == reactionType;

      // Store original post for revert
      final originalPost = currentPost;

      // Optimistic UI update
      Data updatedPost;
      if (sameReaction) {
        // Remove reaction
        updatedPost = Data(
          id: currentPost.id,
          user: currentPost.user,
          postType: currentPost.postType,
          privacy: currentPost.privacy,
          title: currentPost.title,
          text: currentPost.text,
          pollTitle: currentPost.pollTitle,
          images: currentPost.images,
          pollOptions: currentPost.pollOptions,
          checkIn: currentPost.checkIn,
          comments: currentPost.comments,
          reactions: currentPost.reactions,
          totalReactions: (currentPost.totalReactions ?? 0) > 0
              ? (currentPost.totalReactions! - 1)
              : 0,
          totalComments: currentPost.totalComments,
          totalPollVotes: currentPost.totalPollVotes,
          isPoll: currentPost.isPoll,
          userReaction: null,
          userPollVote: currentPost.userPollVote,
          isHidden: currentPost.isHidden,
          createdAt: currentPost.createdAt,
          updatedAt: currentPost.updatedAt,
        );
      } else {
        // Add or change reaction
        final newReactionCount = hadReaction
            ? currentPost.totalReactions
            : (currentPost.totalReactions ?? 0) + 1;

        updatedPost = Data(
          id: currentPost.id,
          user: currentPost.user,
          postType: currentPost.postType,
          privacy: currentPost.privacy,
          title: currentPost.title,
          text: currentPost.text,
          pollTitle: currentPost.pollTitle,
          images: currentPost.images,
          pollOptions: currentPost.pollOptions,
          checkIn: currentPost.checkIn,
          comments: currentPost.comments,
          reactions: currentPost.reactions,
          totalReactions: newReactionCount,
          totalComments: currentPost.totalComments,
          totalPollVotes: currentPost.totalPollVotes,
          isPoll: currentPost.isPoll,
          userReaction: {
            'id': 0,
            'type': reactionType,
            'created_at': DateTime.now().toIso8601String(),
          },
          userPollVote: currentPost.userPollVote,
          isHidden: currentPost.isHidden,
          createdAt: currentPost.createdAt,
          updatedAt: currentPost.updatedAt,
        );
      }

      posts[postIndex] = updatedPost;

      // API call
      final response = await _repository.addPostReaction(
        postId: postId,
        reactionType: reactionType,
      );

      if (response['success'] != true) {
        // Revert on failure
        posts[postIndex] = originalPost;
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to react');
      }
    } catch (e) {
      // Revert on error
      loadPosts();
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // Hide Post
  Future<void> hidePost(int? postId) async {
    if (postId == null) return;

    try {
      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return;

      // Optimistic UI update
      final currentPost = posts[postIndex];
      posts.removeAt(postIndex);

      final response = await _repository.hidePost(postId: postId);

      if (response['success'] == true) {
        Utils.successSnackBar('Success', 'Post hidden successfully');
      } else {
        // Revert on failure
        posts.insert(postIndex, currentPost);
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to hide post');
      }
    } catch (e) {
      loadPosts();
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // Unhide Post
  Future<void> unhidePost(int? postId) async {
    if (postId == null) return;

    try {
      final response = await _repository.unhidePost(postId: postId);

      if (response['success'] == true) {
        Utils.successSnackBar('Success', 'Post unhidden successfully');
        loadPosts(); // Reload to show unhidden post
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to unhide post');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // Delete Post
  Future<void> deletePost(int? postId) async {
    if (postId == null) return;

    try {
      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return;

      // Optimistic UI update
      final currentPost = posts[postIndex];
      posts.removeAt(postIndex);

      final response = await _repository.deletePost(postId: postId);

      if (response['success'] == true) {
        Utils.successSnackBar('Success', 'Post deleted successfully');
      } else {
        // Revert on failure
        posts.insert(postIndex, currentPost);
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to delete post');
      }
    } catch (e) {
      loadPosts();
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // Vote on Poll
  Future<void> voteOnPoll(int? postId, dynamic pollOptionId) async {
    if (postId == null || pollOptionId == null) return;

    try {
      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return;

      final currentPost = posts[postIndex];
      if (currentPost.isPoll != true || currentPost.pollOptions.isEmpty) return;

      // Check if already voted - handle different types of userPollVote
      bool alreadyVoted = false;
      if (currentPost.userPollVote != null) {
        if (currentPost.userPollVote is Map) {
          alreadyVoted = true;
        } else if (currentPost.userPollVote is int) {
          alreadyVoted = true;
        }
      }

      if (alreadyVoted) {
        Utils.infoSnackBar('Info', 'You have already voted on this poll');
        return;
      }

      final response = await _repository.voteOnPoll(
        postId: postId,
        pollOptionId: pollOptionId is int ? pollOptionId : int.tryParse(pollOptionId.toString()) ?? 0,
      );

      if (response['success'] == true) {
        Utils.successSnackBar('Success', 'Vote submitted successfully');
        // Reload post to get updated poll results
        loadPosts();
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to vote');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // Remove Poll Vote
  Future<void> removeVoteFromPoll(int? postId, int? pollOptionId) async {
    if (postId == null || pollOptionId == null) return;

    try {
      final response = await _repository.removeVoteFromPoll(
        postId: postId,
        pollOptionId: pollOptionId,
      );

      if (response['success'] == true) {
        Utils.successSnackBar('Success', 'Vote removed successfully');
        loadPosts();
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to remove vote');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // Get Poll Results
  Future<void> getPollResults(int? postId) async {
    if (postId == null) return;

    try {
      final response = await _repository.getPollResults(postId: postId);

      if (response['success'] == true) {
        // Update the specific post with new poll data
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          loadPosts(); // Reload to get fresh data
        }
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // Show Reaction Picker
  void showReactionPickerForPost(int postId) {
    selectedPostIdForReaction.value = postId;
    showReactionPicker.value = true;
  }

  // Hide Reaction Picker
  void hideReactionPickerDialog() {
    showReactionPicker.value = false;
    selectedPostIdForReaction.value = 0;
  }
}