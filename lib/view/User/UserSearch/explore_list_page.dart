import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/User/UserSearch/widgets/explore_card_list.dart';

import '../../../View_Model/Controller/user/userSearch/explore_controller.dart';
import 'widgets/search_bar.dart';

class ExploreListPage extends StatelessWidget {
  final controller = Get.find<ExploreController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text("All Events"),    backgroundColor: Colors.transparent,),
        body: Column(
          children: [
            SearchBarWidget(controller: controller),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: ['all', 'restaurant', 'bar', 'club_event'].map((cat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Obx(() => ChoiceChip(
                      label: Text(cat.toUpperCase()),
                      selected: controller.selectedCategory.value == cat,
                      onSelected: (_) => controller.filterByCategory(cat),
                    )),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: Obx(() => ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: controller.filteredItems.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredItems[index];
                  return ExploreCard(item: item); // uses single card
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
