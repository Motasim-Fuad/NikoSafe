import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/User/UserProfile/Screen/user_history/user_parchase_history/user_parchase_historyView.dart';
import 'package:nikosafe/view/User/UserProfile/Screen/user_history/user_services_venue_bookingView/user_services_andVanueBokkingView.dart';
import '../../../../../View_Model/Controller/user/MyProfile/userHistoryTapController.dart';


class UserHistoryScreen extends StatelessWidget {
  final historyController = Get.put(UserHistoryTapController());


  UserHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor:Colors.transparent,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          title: const Text('History', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body:

        Column(
          children: [
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
                            onTap: () => historyController.switchTab(0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: historyController.currentTab.value == 0
                                    ? const Color(0xFF1D5A60)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  'Service & Venue Bookings',
                                  style: TextStyle(
                                    color: historyController.currentTab.value == 0
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                           //SizedBox(width: 5,),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => historyController.switchTab(1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: historyController.currentTab.value == 1
                                    ? const Color(0xFF1D5A60)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  'Purchase History',
                                  style: TextStyle(
                                    color: historyController.currentTab.value == 1
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
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
              child: Obx(() => historyController.currentTab.value == 0
                  ?UserServicesAndvanuebokkingview()
                  :UserParchaseHistoryview() ),
            ),
          ],
        ),
      ),
    );
  }
}
