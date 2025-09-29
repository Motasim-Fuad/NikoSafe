// models/userHome/comment_model.dart

class CommentModel {
  CommentModel({
    required this.success,
    required this.message,
    required this.timestamp,
    required this.statusCode,
    required this.data,
  });

  final bool? success;
  final String? message;
  final DateTime? timestamp;
  final int? statusCode;
  final List<CommentData>? data;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      success: json["success"],
      message: json["message"],
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      statusCode: json["status_code"],
      data: json["data"] == null
          ? []
          : List<CommentData>.from(json["data"].map((x) => CommentData.fromJson(x))),
    );
  }
}

class CommentData {
  CommentData({
    required this.id,
    required this.user,
    required this.post,
    required this.text,
    required this.title,
    required this.parentComment,
    required this.replies,
    required this.totalReactions,
    required this.userReaction,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final CommentUser? user;
  final int? post;
  final String? text;
  final String? title;
  final int? parentComment;
  final List<CommentData>? replies;
  final int? totalReactions;
  final dynamic userReaction;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      id: json["id"],
      user: json["user"] == null ? null : CommentUser.fromJson(json["user"]),
      post: json["post"],
      text: json["text"],
      title: json["title"],
      parentComment: json["parent_comment"],
      replies: json["replies"] == null
          ? []
          : List<CommentData>.from(json["replies"].map((x) => CommentData.fromJson(x))),
      totalReactions: json["total_reactions"],
      userReaction: json["user_reaction"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class CommentUser {
  CommentUser({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  final int? id;
  final String? email;
  final dynamic username;
  final String? firstName;
  final String? lastName;

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json["id"],
      email: json["email"],
      username: json["username"],
      firstName: json["first_name"],
      lastName: json["last_name"],
    );
  }
}