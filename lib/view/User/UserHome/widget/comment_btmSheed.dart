// views/user/userHome/widgets/comment_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/comment_controller.dart';
import 'package:nikosafe/models/User/userHome/comment_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

class CommentBottomSheet extends StatelessWidget {
  final int postId;

  const CommentBottomSheet({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController());

    // Load comments when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadComments(postId);
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColor.midLinear,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade800),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Comments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),

          // Comments List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: AppColor.iconColor),
                );
              }

              if (controller.comments.isEmpty) {
                return Center(
                  child: Text(
                    'No comments yet.\nBe the first to comment!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  final comment = controller.comments[index];
                  return CommentItem(
                    comment: comment,
                    controller: controller,
                  );
                },
              );
            }),
          ),

          // Reply indicator
          Obx(() {
            if (controller.replyingTo.value != null) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColor.topLinear,
                child: Row(
                  children: [
                    Text(
                      'Replying to ${controller.replyingTo.value!.user?.firstName ?? "User"}',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => controller.cancelReply(),
                      icon: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          }),

          // Edit indicator
          Obx(() {
            if (controller.isEditing.value && controller.editingComment.value != null) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.orange.shade900.withOpacity(0.3),
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Editing comment',
                      style: TextStyle(color: Colors.orange),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => controller.cancelEdit(),
                      icon: Icon(Icons.close, color: Colors.orange, size: 20),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          }),

          // Comment Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.iconColor,
              border: Border(
                top: BorderSide(color: Colors.grey.shade800),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller.commentTextController,
                      style: TextStyle(color: Colors.white),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Obx(() => IconButton(
                    onPressed: controller.isPosting.value
                        ? null
                        : () {
                      if (controller.isEditing.value) {
                        controller.updateComment();
                      } else {
                        controller.createComment();
                      }
                    },
                    icon: controller.isPosting.value
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Icon(
                      controller.isEditing.value ? Icons.check : Icons.send,
                      color: Colors.white,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  final CommentData comment;
  final CommentController controller;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract reaction type safely
    String? userReactionType;
    if (comment.userReaction != null) {
      if (comment.userReaction is Map<String, dynamic>) {
        userReactionType = (comment.userReaction as Map<String, dynamic>)['type'] as String?;
      } else if (comment.userReaction is String) {
        userReactionType = comment.userReaction as String;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [

                        Text(comment.user!.email ??"",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        Text(
                          '${comment.user?.firstName ?? "User"} ${comment.user?.lastName ?? ""}'.trim(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          comment.createdAt != null
                              ? _formatTimeAgo(comment.createdAt!)
                              : '',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    if (comment.title != null && comment.title!.isNotEmpty)
                      Text(
                        comment.title!,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                      comment.text ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        // React button
                        InkWell(
                          onTap: () => _showReactionPicker(context),
                          onLongPress: () => _showReactionPicker(context),
                          child: Row(
                            children: [
                              Icon(
                                userReactionType != null
                                    ? _getReactionIcon(userReactionType)
                                    : Icons.favorite_border,
                                size: 18,
                                color: userReactionType != null
                                    ? _getReactionColor(userReactionType)
                                    : Colors.grey,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${comment.totalReactions ?? 0}',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        // Reply button
                        InkWell(
                          onTap: () => controller.setReplyTo(comment),
                          child: Text(
                            'Reply',
                            style: TextStyle(
                              color: AppColor.secondaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.grey),
                color: AppColor.iconColor,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('Edit', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete' && comment.id != null) {
                    _showDeleteConfirmation(context);
                  } else if (value == 'edit' && comment.id != null) {
                    controller.startEditing(comment);
                  }
                },
              ),
            ],
          ),
          // Show Replies
          if (comment.replies != null && comment.replies!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 40, top: 12),
              child: Column(
                children: comment.replies!.map((reply) {
                  return CommentItem(
                    comment: reply,
                    controller: controller,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _showReactionPicker(BuildContext context) {
    final reactionTypes = ['like', 'love', 'laugh', 'angry', 'sad', 'wow'];

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.iconColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'React to this comment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: reactionTypes.map((type) {
                return GestureDetector(
                  onTap: () {
                    controller.toggleCommentReaction(comment.id!, type);
                    Get.back();
                  },
                  child: Column(
                    children: [
                      Icon(
                        _getReactionIcon(type),
                        size: 36,
                        color: _getReactionColor(type),
                      ),
                      SizedBox(height: 6),
                      Text(
                        _capitalizeFirst(type),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.iconColor,
        title: Text('Delete Comment', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this comment?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteComment(comment.id!);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  IconData _getReactionIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.thumb_up;
      case 'love':
        return Icons.favorite;
      case 'laugh':
        return Icons.sentiment_very_satisfied;
      case 'angry':
        return Icons.sentiment_very_dissatisfied;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'wow':
        return Icons.sentiment_satisfied_alt;
      default:
        return Icons.thumb_up;
    }
  }

  Color _getReactionColor(String type) {
    switch (type) {
      case 'like':
        return Colors.blue;
      case 'love':
        return Colors.red;
      case 'laugh':
        return Colors.yellow;
      case 'angry':
        return Colors.orange;
      case 'sad':
        return Colors.grey;
      case 'wow':
        return Colors.purple;
      default:
        return Colors.cyan;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}