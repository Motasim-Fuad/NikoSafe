

import 'UserLocation/user_location_model.dart';

class UserCreatePostModel {
  final String? id;
  final String description;
  final List<String> tags;
  final List<String> photoUrls;
  final UserLocationModel? location;
  final String status; // e.g., 'Public', 'Private'

  UserCreatePostModel({
    this.id,
    required this.description,
    this.tags = const [],
    this.photoUrls = const [],
    this.location,
    this.status = 'Public',
  });

  // Factory constructor to create a PostModel from a map
  factory UserCreatePostModel.fromJson(Map<String, dynamic> json) {
    return UserCreatePostModel(
      id: json['id'],
      description: json['description'],
      tags: List<String>.from(json['tags'] ?? []),
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      location: json['location'] != null
          ? UserLocationModel.fromJson(json['location'])
          : null,
      status: json['status'] ?? 'Public',
    );
  }

  // Convert PostModel to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'tags': tags,
      'photoUrls': photoUrls,
      'location': location?.toJson(),
      'status': status,
    };
  }
}