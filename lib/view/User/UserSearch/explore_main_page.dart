// Path: view/User/UserSearch/explore_main_page.dart
// COMPLETE FILE - Replace entire file

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/view/User/UserSearch/widgets/CustomSectionButton.dart';
import 'package:nikosafe/view/User/UserSearch/widgets/explore_card_carousel.dart';
import '../../../View_Model/Controller/user/userSearch/explore_controller.dart';
import 'explore_list_page.dart';

class ExploreMainPage extends StatelessWidget {
  final controller = Get.put(ExploreController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Explore",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Obx(() {
          // Show loading indicator while fetching data
          if (controller.isLoading.value && controller.allItems.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.limeColor,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: AppColor.limeColor,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomSectionButton(
                            title: "Find a Ride",
                            icon: SvgPicture.asset(ImageAssets.car),
                            onPress: () {},
                            height: size.height * 0.07,
                            width: size.width * 0.4,
                            loading: false,
                            textColor: Colors.white,
                          ),
                          SizedBox(width: 20),
                          CustomSectionButton(
                            title: "Service Provider",
                            icon: SvgPicture.asset(ImageAssets.services),
                            onPress: () {
                              Get.toNamed(RouteName.userserviceproviderlistview);
                            },
                            height: size.height * 0.07,
                            width: size.width * 0.5,
                            loading: false,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Trending This Week",
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  section("Nearby Restaurant", 'restaurant'),
                  section("Nearby Bars", 'bar'),
                  section("Nearby Club events", 'club_event'),
                ],
              ),
            ),
          );
        }),
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
        Obx(
              () {
            final items = controller.allItems
                .where((e) => e.category == category)
                .toList();

            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'No venues available',
                    style: TextStyle(
                      color: AppColor.primaryTextColor.withOpacity(0.6),
                    ),
                  ),
                ),
              );
            }

            return ExploreCardCarousel(items: items);
          },
        ),
      ],
    );
  }
}