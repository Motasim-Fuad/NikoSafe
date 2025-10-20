// view/User/UserProfile/ViewProfileDetails/my_profile_details_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/MyProfile/my_profile_details_controller/my_profile_detailsController.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/view/User/UserProfile/ViewProfileDetails/all_connects_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyProfileDetailsView extends StatelessWidget {
  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF253038),
      appBar: AppBar(
        title: const Text('Profile Details', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF253038),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.refreshProfile(),
          ),
        ],
      ),
      body: Obx(() {
        // Loading State
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.tealAccent),
          );
        }

        // Error State
        if (controller.errorMessage.value.isNotEmpty && controller.profile.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                    ),
                    child: const Text('Retry', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          );
        }

        final user = controller.profile.value;
        if (user == null) {
          return const Center(
            child: Text('No profile data', style: TextStyle(color: Colors.white)),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshProfile(),
          color: Colors.tealAccent,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Picture
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[800],
                  child: user.displayImage != null
                      ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.displayImage!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(
                        color: Colors.tealAccent,
                        strokeWidth: 2,
                      ),
                      errorWidget: (context, url, error) {
                        print('❌ Profile image load error: $error');
                        print('   Failed URL: $url');
                        return Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey[600],
                        );
                      },
                    ),
                  )
                      : Icon(Icons.person, size: 40, color: Colors.grey[600]),
                ),

                const SizedBox(height: 10),

                // User Name
                Text(
                  user.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                // Email
                Text(
                  user.email,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),

                const SizedBox(height: 20),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Posts Count
                    Column(
                      children: [
                        Text(
                          '${user.postsCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Posts',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),

                    const SizedBox(width: 50),

                    // Friends Count
                    GestureDetector(
                      onTap: () => Get.to(() => AllConnectsView()),
                      child: Column(
                        children: [
                          Text(
                            '${user.friendsCount}',
                            style: const TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Connect',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Gallery Section
                user.galleryImages.isEmpty
                    ? Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(Icons.photo_library, size: 60, color: Colors.grey[600]),
                      const SizedBox(height: 10),
                      Text(
                        'No photos yet',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    ],
                  ),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Gallery (${user.galleryImages.length})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: user.galleryImages.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemBuilder: (context, index) {
                        final imageUrl = user.galleryImages[index];
                        print('🖼️ Loading gallery image: $imageUrl');

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.tealAccent,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              print('❌ Gallery image load error: $error');
                              print('   Failed URL: $url');
                              return Container(
                                color: Colors.grey[800],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error, color: Colors.grey[600], size: 20),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Failed',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}