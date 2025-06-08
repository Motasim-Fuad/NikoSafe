import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/view/User/UserHome/widget/connectTapView.dart';
import 'package:nikosafe/view/User/UserHome/widget/feedTapView.dart';
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
                        color: const Color(0xFF294045),
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

                  // Right-aligned icon
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){

                          },
                          child: CircleAvatar(
                            radius: 23,
                            backgroundColor: AppColor.iconColor,
                            child:SvgPicture.asset(ImageAssets.userHome_location) ,
                          ),
                        ),

                        Text("Share Location",style: TextStyle(color: AppColor.primaryTextColor),),
                      ],
                    ),
                  ),
                ],
              ),



              Expanded(
                child: Obx(() => tabController.currentTab.value == 0
                    ? FeedTabView(controller: feedController)
                    : ConnectTabView()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
