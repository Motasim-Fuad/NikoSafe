// View_Model/Controller/user/userHome/comment_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/userHome_repo/comment_repo.dart';
import 'package:nikosafe/models/userHome/comment_model.dart';
import 'package:nikosafe/utils/utils.dart';

class CommentController extends GetxController {
  final CommentRepository _repository = CommentRepository();

  RxList<CommentData> comments = <CommentData>[].obs;
  RxBool isLoading = false.obs;
  RxBool isPosting = false.obs;

  final TextEditingController commentTextController = TextEditingController();
  final TextEditingController titleTextController = TextEditingController();

  // For reply functionality
  Rx<CommentData?> replyingTo = Rx<CommentData?>(null);

  // For edit functionality
  RxBool isEditing = false.obs;
  Rx<CommentData?> editingComment = Rx<CommentData?>(null);

  int? currentPostId;

  @override
  void onClose() {
    commentTextController.dispose();
    titleTextController.dispose();
    super.onClose();
  }

  // Load Comments for a Post
  Future<void> loadComments(int postId) async {
    try {
      currentPostId = postId;
      isLoading.value = true;

      final response = await _repository.fetchComments(postId: postId);

      if (response['success'] == true) {
        final List<dynamic> commentsData = response['data'] ?? [];
        comments.value = commentsData.map((json) => CommentData.fromJson(json)).toList();
        print("Loaded ${comments.length} comments");
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to load comments');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      print("Error loading comments: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Create Comment
  Future<void> createComment() async {
    if (currentPostId == null) return;

    final text = commentTextController.text.trim();
    if (text.isEmpty) {
      Utils.errorSnackBar('Error', 'Please enter a comment');
      return;
    }

    try {
      isPosting.value = true;

      final response = await _repository.createComment(
        postId: currentPostId!,
        text: text,
        title: titleTextController.text.trim().isEmpty ? null : titleTextController.text.trim(),
        parentCommentId: replyingTo.value?.id,
      );

      if (response['success'] == true) {
        Utils.successSnackBar('Success', 'Comment posted successfully');
        commentTextController.clear();
        titleTextController.clear();
        replyingTo.value = null;

        // Reload comments
        await loadComments(currentPostId!);
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to post comment');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      print("Error creating comment: $e");
    } finally {
      isPosting.value = false;
    }
  }

  // Update Comment
  Future<void> updateComment() async {
    if (editingComment.value == null) return;

    final text = commentTextController.text.trim();
    if (text.isEmpty) {
      Utils.errorSnackBar('Error', 'Please enter a comment');
      return;
    }

    try {
      isPosting.value = true;

      final response = await _repository.updateComment(
        commentId: editingComment.value!.id!,
        text: text,
      );

      if (response['success'] == true) {
        Utils.successSnackBar('Success', 'Comment updated successfully');
        commentTextController.clear();
        cancelEdit();

        if (currentPostId != null) {
          await loadComments(currentPostId!);
        }
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to update comment');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      print("Error updating comment: $e");
    } finally {
      isPosting.value = false;
    }
  }

  // Delete Comment
  Future<void> deleteComment(int commentId) async {
    try {
      final response = await _repository.deleteComment(commentId: commentId);

      print("Delete response: $response");

      if (response['success'] == true) {
        Utils.successSnackBar('Success', 'Comment deleted successfully');

        // Remove from list optimistically
        comments.removeWhere((comment) => comment.id == commentId);

        // Also remove from nested replies
        for (var comment in comments) {
          comment.replies?.removeWhere((reply) => reply.id == commentId);
        }
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to delete comment');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      print("Error deleting comment: $e");
    }
  }

  // Add or Remove Reaction to Comment
  Future<void> toggleCommentReaction(int commentId, String reactionType) async {
    try {
      // Find the comment
      CommentData? targetComment;
      for (var comment in comments) {
        if (comment.id == commentId) {
          targetComment = comment;
          break;
        }
        // Check in replies
        if (comment.replies != null) {
          for (var reply in comment.replies!) {
            if (reply.id == commentId) {
              targetComment = reply;
              break;
            }
          }
        }
      }

      if (targetComment == null) return;

      // Check if user already reacted
      String? currentReaction;
      if (targetComment.userReaction != null) {
        if (targetComment.userReaction is Map<String, dynamic>) {
          currentReaction = (targetComment.userReaction as Map<String, dynamic>)['type'] as String?;
        } else if (targetComment.userReaction is String) {
          currentReaction = targetComment.userReaction as String;
        }
      }

      final response = await _repository.addCommentReaction(
        commentId: commentId,
        reactionType: reactionType,
      );

      if (response['success'] == true) {
        // Reload to get updated reactions
        if (currentPostId != null) {
          await loadComments(currentPostId!);
        }
      } else {
        Utils.errorSnackBar('Error', response['message'] ?? 'Failed to react');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      print("Error toggling reaction: $e");
    }
  }

  // Set Reply To
  void setReplyTo(CommentData comment) {
    replyingTo.value = comment;
    cancelEdit(); // Cancel editing if replying
    commentTextController.clear();
  }

  // Cancel Reply
  void cancelReply() {
    replyingTo.value = null;
  }

  // Start Editing
  void startEditing(CommentData comment) {
    isEditing.value = true;
    editingComment.value = comment;
    commentTextController.text = comment.text ?? '';
    cancelReply(); // Cancel replying if editing
  }

  // Cancel Edit
  void cancelEdit() {
    isEditing.value = false;
    editingComment.value = null;
    commentTextController.clear();
  }
}