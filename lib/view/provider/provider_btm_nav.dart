import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/provider/ProviderData/provider_data.dart';
import 'package:nikosafe/view/provider/ProviderHome/provider_home_view.dart';
import 'package:nikosafe/view/provider/ProviderProfile/provider_profile_view.dart';



import '../../View_Model/Controller/provider/providerBtmNavController.dart';
import 'ProviderTaskManagement/providerTaskManagement.dart';

class ProviderBtmNavView extends StatelessWidget {
  ProviderBtmNavView({super.key});

  final Providerbtmnavcontroller controller = Get.put(Providerbtmnavcontroller());

  final List<Widget> _pages = [
    ProviderHomeView(),

    ProvidertaskmanagementView(),
    ProviderEarningDataView(),
    ProviderProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // App-wide background color
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Obx(() => ConvexAppBar(
        style: TabStyle.flip,
        backgroundColor: AppColor.navbarColor,
        activeColor: Colors.cyanAccent,
        color: Colors.grey,
        initialActiveIndex: controller.selectedIndex.value,
        onTap: controller.changePage,
        items:  [
          TabItem(icon: Icons.home, title: "Home"),
          TabItem(icon: FontAwesomeIcons.fileLines, title: "Task"),
          TabItem(icon: FontAwesomeIcons.chartColumn, title: "Chart"),
          TabItem(icon: Icons.person, title: "Profile"),
        ],
      )),
    );
  }
}
