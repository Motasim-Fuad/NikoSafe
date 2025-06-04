import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserBtmNavcontroller extends GetxController {
  final PageController pageController = PageController();
  final RxInt selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
