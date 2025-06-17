import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/User/UserSearch/widgets/explore_card_list.dart';

import '../../../View_Model/Controller/user/userSearch/explore_controller.dart';
import 'widgets/search_bar.dart';

class ExploreListPage extends StatelessWidget {
  final controller = Get.find<ExploreController>();

  final Map<String, String> categoryLabels = {
    'all': 'All',
    'restaurant': 'Restaurant',
    'bar': 'Bars',
    'club_event': 'Club events',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Explore",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBarWidget(controller: controller),
            ),
                // Bannner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildBanner(),
            ),
            // Rounded tab container
            Obx(() => Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFF1C2F34),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: categoryLabels.entries.map((entry) {
                  final key = entry.key;
                  final label = entry.value;
                  final isSelected = controller.selectedCategory.value == key;

                  return GestureDetector(
                    onTap: () => controller.filterByCategory(key),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF2D6A7B) : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )),

            // List of filtered items
            Expanded(
              child: Obx(() => ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: controller.filteredItems.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredItems[index];
                  return ExploreCard(item: item);
                },
              )),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Optional: for background color
        ),
        child: Stack(
          children: [
            Image.asset(
              ImageAssets.club_even1,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Celebrate Taco Tuesday!",
                    style: TextStyle(color: AppColor.primaryTextColor,fontSize: 25,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8,),
                  Text(
                   "Details like Buy 1 Get 1 Free on Tacos from 5–9 PM"
                      ,style: TextStyle(color: AppColor.primaryTextColor)
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_month,color: AppColor.primaryTextColor),
                          Text("May 10",style: TextStyle(color: AppColor.primaryTextColor)),
                        ],
                      ),
                      SizedBox(width: 8,),
                      Row(
                        children: [
                          Icon(Icons.access_time,color: AppColor.primaryTextColor),
                          Text("8:00 PM – 1:00 AM",style: TextStyle(color: AppColor.primaryTextColor)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 90),
                 Row(
                   children: [
                     Icon(Icons.location_on_outlined,color: AppColor.primaryTextColor,),
                     SizedBox(width: 8,),
                     Text("Luna Lounge, Downtown LA",style: TextStyle(color: AppColor.primaryTextColor),)
                   ],
                 )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
