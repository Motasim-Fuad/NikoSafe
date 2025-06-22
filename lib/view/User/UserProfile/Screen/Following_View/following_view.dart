import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userSearch/explore_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class FollowingView extends StatelessWidget {
  const FollowingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ExploreController controller = Get.put(ExploreController());

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: CustomBackButton(),
        title: Text("You Are Following ", style: TextStyle(color: AppColor.primaryTextColor),),),
        body: Obx(() {
          final following = controller.followedItems
              .where((item) => item.category != 'club_event')
              .toList();

          if (following.isEmpty) {
            return Center(
              child: Text("No followed items.", style: TextStyle(color: Colors.white)),
            );
          }

          return ListView.builder(
            itemCount: following.length,
            itemBuilder: (context, index) {
              final item = following[index];
              return ListTile(
                leading: Image.asset(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                title: Text(item.title, style: TextStyle(color: Colors.white)),
                subtitle: Text(item.location, style: TextStyle(color: Colors.white70)),
                trailing: TextButton(
                  onPressed: () {
                    controller.toggleFollow(item);
                  },
                  child: Text("Unfollow", style: TextStyle(color: Colors.redAccent)),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
