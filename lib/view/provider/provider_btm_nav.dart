import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:nikosafe/view/provider/ProviderData/provider_data.dart';
import 'package:nikosafe/view/provider/ProviderHome/provider_home.dart';

import 'package:nikosafe/view/provider/ProviderProfile/provider_profile_view.dart';
import 'package:nikosafe/view/provider/ProviderScanner/provider_scanner_view.dart';
import 'package:nikosafe/view/provider/ProviderSearch/provider_search_view.dart';


import '../../View_Model/Controller/provider/providerBtmNavController.dart';

class ProviderBtmNavView extends StatelessWidget {
  ProviderBtmNavView({super.key});

  final Providerbtmnavcontroller controller = Get.put(Providerbtmnavcontroller());

  final List<Widget> _pages = [
    ProviderHomeView(),
    ProviderSearchView(),
    ProviderScannerView(),
    ProviderDataView(),
    ProviderProfileView(),
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
