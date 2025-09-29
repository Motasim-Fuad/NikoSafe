import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/User/UserHome/connectTapView.dart';
import 'package:nikosafe/view/User/UserHome/feedTapView.dart';
import 'package:nikosafe/view/User/UserHome/widget/userhomewidgets.dart';
import '../../../View_Model/Controller/user/userHome/feedController.dart';
import '../../../View_Model/Controller/user/userHome/userHomeTapController.dart';


class UserHomeView extends StatelessWidget {
  UserHomeView({super.key});

  final feedController = Get.put(FeedController());
  final tabController = Get.put(UserHomeTabController()); // <--- Put the controller

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              topBar(),
              Obx(() =>
              feedController.showHealthCard.value && tabController.currentTab.value == 0
                  ? healthCard(feedController)
                  : const SizedBox.shrink()
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(() => Container(
                      padding: const EdgeInsets.all(3),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColor.iconColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => tabController.switchTab(0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: tabController.currentTab.value == 0
                                      ? const Color(0xFF1D5A60)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Feed',
                                  style: TextStyle(
                                    color: tabController.currentTab.value == 0
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => tabController.switchTab(1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: tabController.currentTab.value == 1
                                      ? const Color(0xFF1D5A60)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Connect',
                                  style: TextStyle(
                                    color: tabController.currentTab.value == 1
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),

              Expanded(
                child: PageView(
                  controller: tabController.pageController,
                  onPageChanged: (index) {
                    tabController.currentTab.value = index;
                  },
                  children: [
                    FeedTabView(controller: feedController),
                    ConnectTabView(),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
