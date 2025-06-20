import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHomeTabController extends GetxController {
  final currentTab = 0.obs;
  final pageController = PageController();

  void switchTab(int index) {
    currentTab.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
