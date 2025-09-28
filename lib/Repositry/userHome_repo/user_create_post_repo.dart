

import 'dart:io';

import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/models/userCreatePost/user_create_post_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class UserPostRepository {

  final _apiService = NetworkApiServices();
  Future<bool> createPost(UserCreatePostModel post, {List<File>? images}) async {
    try {
      final Map<String, dynamic> data = {
        'post_type': post.postType ?? '1',
        'title': post.title ?? '',
        'text': post.description,
        'privacy': _mapPrivacyToId(post.status ?? 'Public'),
      };

      // Add location data if available
      if (post.location != null) {
        data.addAll({
          'location_name': post.location!.name ?? '',
          'latitude': post.location!.latitude?.toString() ?? '',
          'longitude': post.location!.longitude?.toString() ?? '',
          'address': post.location!.address ?? '',
        });
      }

      // Add tags if available
      if (post.tags != null && post.tags!.isNotEmpty) {
        data['tags'] = post.tags!.join(',');
      }

      // If there are multiple images, send the first one as main image
      File? mainImage = images != null && images.isNotEmpty ? images.first : null;

      final response = await _apiService.postMultipartApi(
        url: AppUrl.socialCreatePosts,
        data: data,
        imageFile: mainImage,
        imageFieldName: 'images',
        requireAuth: true,
      );

      return response != null &&
          (response['success'] == true ||
              response['status_code'] == 201);
    } catch (e) {
      print('Error creating post: $e');
      rethrow;
    }
  }

  String _mapPrivacyToId(String privacy) {
    switch (privacy.toLowerCase()) {
      case 'public':
        return '1';
      case 'friends':
      case 'connect':
        return '2';
      case 'private':
      case 'only me':
        return '3';
      default:
        return '1';
    }
  }
}