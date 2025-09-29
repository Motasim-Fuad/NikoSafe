// view/User/UserHome/feed_tab_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/feedController.dart';
import 'package:nikosafe/view/User/UserHome/widget/post_card_widgats.dart';
import 'package:nikosafe/view/User/UserHome/widget/userhomewidgets.dart';
import '../../../resource/Colors/app_colors.dart';

class FeedTabView extends StatelessWidget {
  final FeedController controller;

  const FeedTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// Loading State
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.cyan),
        );
      }

      /// Empty State (with RefreshIndicator)
      if (controller.posts.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.refreshPosts,
          color: Colors.cyan,
          backgroundColor: AppColor.iconColor,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.feed_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No posts yet',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Pull down to refresh',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      /// Feed List with RefreshIndicator
      return RefreshIndicator(
        onRefresh: controller.refreshPosts,
        color: Colors.cyan,
        backgroundColor: AppColor.iconColor,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.posts.length +
              (controller.showHealthCard.value ? 1 : 0),
          itemBuilder: (context, index) {
            // Show health card at the top if enabled
            if (controller.showHealthCard.value && index == 0) {
              return healthCard(controller);
            }

            // Adjust index if health card is shown
            final postIndex =
            controller.showHealthCard.value ? index - 1 : index;

            if (postIndex < 0 || postIndex >= controller.posts.length) {
              return const SizedBox.shrink(); // avoid RangeError
            }

            return PostCardWidget(
              post: controller.posts[postIndex],
              controller: controller,
            );
          },
        ),
      );
    });
  }
}
