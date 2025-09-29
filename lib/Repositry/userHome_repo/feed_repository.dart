// Repository/userHome_repo/feed_repository.dart

import 'package:nikosafe/data/network/network_api_services.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class FeedRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // Get Timeline/Feed Posts
  Future<Map<String, dynamic>> fetchFeedPosts() async {
    try {
      final response = await _apiServices.getApi(
        AppUrl.socialFeedTimeline,
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Add/Update Reaction to Post
  Future<Map<String, dynamic>> addPostReaction({
    required int postId,
    required String reactionType,
  }) async {
    try {
      final response = await _apiServices.postApi(
        {'type': reactionType},
        '${AppUrl.socialPostReactions}$postId/react/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Remove Reaction from Post
  Future<Map<String, dynamic>> removePostReaction({
    required int postId,
  }) async {
    try {
      final response = await _apiServices.postApi(
        {'type': 'like'}, // Send any type for deletion
        '${AppUrl.socialPostReactions}$postId/react/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Hide Post
  Future<Map<String, dynamic>> hidePost({required int postId}) async {
    try {
      final response = await _apiServices.postApi(
        {},
        '${AppUrl.socialHidePost}$postId/hide/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Unhide Post
  Future<Map<String, dynamic>> unhidePost({required int postId}) async {
    try {
      final response = await _apiServices.postApi(
        {},
        '${AppUrl.socialUnhidePost}$postId/unhide/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Vote on Poll
  Future<Map<String, dynamic>> voteOnPoll({
    required int postId,
    required int pollOptionId,
  }) async {
    try {
      final response = await _apiServices.postApi(
        {'poll_option_id': pollOptionId},
        '${AppUrl.socialPollVoting}$postId/vote/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Remove Vote from Poll
  Future<Map<String, dynamic>> removeVoteFromPoll({
    required int postId,
    required int pollOptionId,
  }) async {
    try {
      final response = await _apiServices.postApi(
        {'poll_option_id': pollOptionId},
        '${AppUrl.socialRemovePollVote}$postId/vote/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get Poll Results
  Future<Map<String, dynamic>> getPollResults({required int postId}) async {
    try {
      final response = await _apiServices.getApi(
        '${AppUrl.socialPollVotingResult}$postId/poll-results/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete Post
  Future<Map<String, dynamic>> deletePost({required int postId}) async {
    try {
      // Note: Need to add DELETE method to NetworkApiServices
      final response = await _apiServices.postApi(
        {},
        '${AppUrl.socialDeletePosts}$postId/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}