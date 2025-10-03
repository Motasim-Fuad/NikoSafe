import 'package:nikosafe/models/User/userCreatePost/UserLocation/user_location_model.dart';


class UserCreatePostModel {
  final String? postType;
  final String? title;
  final String description;
  final List<String>? tags;
  final List<String>? photoUrls; // For display purposes
  final UserLocationModel? location;
  final String? status; // Privacy status
  final DateTime? createdAt;
  final String? id;

  UserCreatePostModel({
    this.postType,
    this.title,
    required this.description,
    this.tags,
    this.photoUrls,
    this.location,
    this.status,
    this.createdAt,
    this.id,
  });

  factory UserCreatePostModel.fromJson(Map<String, dynamic> json) {
    return UserCreatePostModel(
      postType: json['post_type']?.toString(),
      title: json['title'],
      description: json['text'] ?? json['description'] ?? '',
      tags: json['tags'] != null
          ? (json['tags'] as String).split(',').map((e) => e.trim()).toList()
          : null,
      photoUrls: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      location: json['location'] != null
          ? UserLocationModel.fromJson(json['location'])
          : null,
      status: json['privacy'] ?? json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      id: json['id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_type': postType,
      'title': title,
      'text': description,
      'tags': tags?.join(','),
      'images': photoUrls,
      'location': location?.toJson(),
      'privacy': status,
      'created_at': createdAt?.toIso8601String(),
      'id': id,
    };
  }

  UserCreatePostModel copyWith({
    String? postType,
    String? title,
    String? description,
    List<String>? tags,
    List<String>? photoUrls,
    UserLocationModel? location,
    String? status,
    DateTime? createdAt,
    String? id,
  }) {
    return UserCreatePostModel(
      postType: postType ?? this.postType,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      photoUrls: photoUrls ?? this.photoUrls,
      location: location ?? this.location,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return 'UserCreatePostModel(postType: $postType, title: $title, description: $description, tags: $tags, location: $location, status: $status, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserCreatePostModel &&
        other.postType == postType &&
        other.title == title &&
        other.description == description &&
        other.status == status &&
        other.id == id;
  }

  @override
  int get hashCode {
    return postType.hashCode ^
    title.hashCode ^
    description.hashCode ^
    status.hashCode ^
    id.hashCode;
  }
}

// Response model for create post API
class CreatePostResponse {
  final bool success;
  final String message;
  final String timestamp;
  final int statusCode;
  final UserCreatePostModel? data;

  CreatePostResponse({
    required this.success,
    required this.message,
    required this.timestamp,
    required this.statusCode,
    this.data,
  });

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) {
    return CreatePostResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      statusCode: json['status_code'] ?? 200,
      data: json['data'] != null
          ? UserCreatePostModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'timestamp': timestamp,
      'status_code': statusCode,
      'data': data?.toJson(),
    };
  }
}