

import 'package:nikosafe/models/userCreatePost/user_create_post_model.dart';

class UserPostRepository {
  // Simulate creating a post by sending it to a backend
  Future<bool> createPost(UserCreatePostModel post) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    print('Simulating post creation:');
    print('Description: ${post.description}');
    print('Tags: ${post.tags}');
    print('Photos: ${post.photoUrls.isEmpty ? 'None' : post.photoUrls.join(', ')}');
    print('Location: ${post.location?.name ?? 'None'}');
    print('Status: ${post.status}');
    // In a real app, you would send this to an API and handle the response
    return true; // Simulate success
  }
}