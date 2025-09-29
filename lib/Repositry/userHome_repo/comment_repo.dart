// Repository/userHome_repo/comment_repository.dart

import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class CommentRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // Get Comments for a Post
  Future<Map<String, dynamic>> fetchComments({required int postId}) async {
    try {
      final response = await _apiServices.getApi(
        '${AppUrl.socialComments}?post=$postId',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Create Comment
  Future<Map<String, dynamic>> createComment({
    required int postId,
    required String text,
    String? title,
    int? parentCommentId,
  }) async {
    try {
      final body = {
        'post': postId,
        'text': text,
        if (title != null && title.isNotEmpty) 'title': title,
        if (parentCommentId != null) 'parent_comment': parentCommentId,
      };

      final response = await _apiServices.postApi(
        body,
        AppUrl.socialComments,
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update Comment
  Future<Map<String, dynamic>> updateComment({
    required int commentId,
    required String text,
  }) async {
    try {
      final response = await _apiServices.putApi(
        {'text': text},
        '${AppUrl.socialComments}$commentId/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete Comment - FIXED
  Future<Map<String, dynamic>> deleteComment({required int commentId}) async {
    try {
      print("Deleting comment with ID: $commentId");
      print("URL: ${AppUrl.socialComments}$commentId/");

      final response = await _apiServices.deleteApi(
        '${AppUrl.socialComments}$commentId/',
        requireAuth: true,
      );

      print("Delete comment response: $response");
      return response;
    } catch (e) {
      print("Delete comment error: $e");
      rethrow;
    }
  }

  // Add Reaction to Comment
  Future<Map<String, dynamic>> addCommentReaction({
    required int commentId,
    required String reactionType,
  }) async {
    try {
      final response = await _apiServices.postApi(
        {'type': reactionType},
        '${AppUrl.socialComments}$commentId/react/',
        requireAuth: true,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}