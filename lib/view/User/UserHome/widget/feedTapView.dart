import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/view/User/UserHome/widget/userhomewidgets.dart';

import '../../../../View_Model/Controller/user/userHome/feedController.dart';

class FeedTabView extends StatelessWidget {
  final FeedController controller;

  const FeedTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: controller.posts.length,
        itemBuilder: (_, i) => buildPostCard(controller.posts[i]),
      );
    });
  }
}
