import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/User/UserSearch/widgets/explore_card_carousel.dart';
import 'package:nikosafe/view/User/UserSearch/widgets/search_bar.dart';

import '../../../View_Model/Controller/user/userSearch/explore_controller.dart';
import 'explore_list_page.dart';

class ExploreMainPage extends StatelessWidget {
  final controller = Get.put(ExploreController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Explore",style: TextStyle(color: AppColor.primaryTextColor,),),
          backgroundColor: Colors.transparent,
        centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SearchBarWidget(controller: controller),
              SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: [
                  Chip(label: Text("Find a Ride")),
                  Chip(label: Text("Therapy sessions")),
                  Chip(label: Text("Service Provider")),
                  Chip(label: Text("Trainer")),
                ],
              ),
              section("Restaurant", 'restaurant'),
              section("Bars", 'bar'),
              section("Club events", 'club_event'),


            ],
          ),
        ),
      ),
    );
  }

  Widget section(String title, String category) {
    Color titleColor;

    // Assign color based on category or title
    switch (category) {
      case 'restaurant':
        titleColor = Colors.teal;
        break;
      case 'bar':
        titleColor = Colors.teal;
        break;
      case 'club_event':
        titleColor = Colors.teal;
        break;
      default:
        titleColor = AppColor.primaryTextColor;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              controller.filterByCategory(category);
              Get.to(() => ExploreListPage());
            },
            child: Text("See All"),
          ),
        ),
        Obx(() => ExploreCardCarousel(
          items: controller.allItems
              .where((e) => e.category == category)
              .toList(),
        )),
      ],
    );
  }

}
