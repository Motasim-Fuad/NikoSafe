import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:nikosafe/View_Model/Controller/user/user_btm_navController.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/User/UserData/user_data_view.dart';
import 'package:nikosafe/view/User/UserHome/user_home.dart';
import 'package:nikosafe/view/User/UserProfile/user_profile_view.dart';
import 'package:nikosafe/view/User/UserScanner/user_scanner_view.dart';
import 'package:nikosafe/view/User/UserSearch/explore_main_page.dart';
import 'package:nikosafe/view/User/UserSearch/user_search_view.dart';


import '../../View_Model/Controller/provider/providerBtmNavController.dart';

class UserBtnNavView extends StatelessWidget {
  UserBtnNavView({super.key});

  final UserBtmNavcontroller controller = Get.put(UserBtmNavcontroller());

  final List<Widget> _pages = [
    UserHomeView(),
   // UserSearchView(),
    ExploreMainPage(),
    UserScannerView(),
    UserDataView(),
    UserProfileView(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1C24), // App-wide background color
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Obx(() => ConvexAppBar(
        style: TabStyle.flip,
        backgroundColor: const Color(0xFF1C2A33),
        activeColor: Colors.cyanAccent,
        color: Colors.grey,
        initialActiveIndex: controller.selectedIndex.value,
        onTap: controller.changePage,
        items:  [
          TabItem(icon: Icons.home, title: "Home"),
          TabItem(icon: Icons.search, title: "Search"),
          TabItem(icon: Icons.qr_code_scanner, title: "Scan"),
          TabItem(icon: FontAwesomeIcons.chartColumn, title: "Chart"),
          TabItem(icon: Icons.person, title: "Profile"),
        ],
      )),
    );
  }
}
