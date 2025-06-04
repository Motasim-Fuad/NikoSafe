import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';

import '../../../../View_Model/Controller/user/userHome/feedController.dart';
import '../../../../models/userHome/post_model.dart';

Widget topBar() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircleAvatar(backgroundImage: AssetImage(ImageAssets.userHome_userProfile)),

        SizedBox(width: 10,),
        PopupMenuButton<String>(
          color: const Color(0xFF1E2A33), // Your desired background color
          onSelected: (value) {
            if (value == 'create_post') {
              // Navigate to create post screen
              Get.toNamed(RouteName.userCreatePostView);
            } else if (value == 'create_poll') {
              // Navigate to create poll screen
              Get.toNamed(RouteName.createPollView);

            } else if (value == 'Check_In') {
              // Navigate to check-in screen

            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'create_post',
              child: Text('Create Post', style: TextStyle(color: Colors.white)),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'create_poll',
              child: Text('Create Poll', style: TextStyle(color: Colors.white)),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'Check_In',
              child: Text('Check In', style: TextStyle(color: Colors.white)),
            ),
          ],
          child: CircleAvatar(
            backgroundColor: AppColor.iconColor,
            maxRadius: 23,
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),






        Spacer(),
        GestureDetector(
          onTap: (){

          },
          child: CircleAvatar(
            backgroundColor: Colors.red,
            maxRadius: 20,
            child: Text("SOS",style: TextStyle(color: AppColor.primaryTextColor),),
          ),
        ),
        SizedBox(width: 16),
        GestureDetector(
          onTap: (){
        Get.toNamed(RouteName.chatListView);
          },
          child: CircleAvatar(
            backgroundColor: AppColor.iconColor,
            maxRadius: 20,
            child:FaIcon(FontAwesomeIcons.comment, color: AppColor.primaryTextColor),
          ),
        ),
        SizedBox(width: 16),
        GestureDetector(
          onTap: (){
            Get.toNamed(RouteName.userNotificationView);
          },
          child: CircleAvatar(
            backgroundColor: AppColor.iconColor,
            maxRadius: 20,
            child: FaIcon(FontAwesomeIcons.bell, color:  AppColor.primaryTextColor),
          ),
        ),
      ],
    ),
  );
}

Widget tabBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      tabItem('Feed', true),
      SizedBox(width: 12),
      tabItem('Connect', false),
    ],
  );
}

Widget tabItem(String text, bool isSelected) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? Color(0xFF1EBEA5) : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: TextStyle(color: Colors.white)),
  );
}

Widget healthCard(FeedController controller) {
  return Container(
    margin: EdgeInsets.all(12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Color(0xFF23343F),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Text('👋', style: TextStyle(fontSize: 20)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            "Your Health Insight\nYou've been staying below 0.05% BAC most nights. Great job moderating!",
            style: TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          onPressed: () {
            controller.showHealthCard.value = false;
          },
          icon: Icon(Icons.close, color: Colors.white),
        ),
      ],
    ),
  );
}


Widget buildPostCard(PostModel post) {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    color: Color(0xFF1B2A33),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(post.userImage)),
          title: Text(post.username, style: TextStyle(color: Colors.white)),
          subtitle: Text('${post.date.month}/${post.date.day}', style: TextStyle(color: Colors.grey)),
          trailing: Icon(Icons.more_vert, color: Colors.white),
        ),
        if (post.isMap)
          Image.asset(post.imageUrl)
        else
          Image.asset(post.imageUrl, fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(post.content, style: TextStyle(color: Colors.white)),
        ),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up, color: Colors.cyan)),
            Text('${post.likes}', style: TextStyle(color: Colors.white)),
            SizedBox(width: 16),
            IconButton(onPressed: () {}, icon: Icon(Icons.comment, color: Colors.white)),
            Text('${post.comments}', style: TextStyle(color: Colors.white)),
            Spacer(),
            if (post.location != null)
              TextButton(
                onPressed: () {},
                child: Text(post.location!, style: TextStyle(color: Colors.cyan)),
              ),
          ],
        )
      ],
    ),
  );
}
