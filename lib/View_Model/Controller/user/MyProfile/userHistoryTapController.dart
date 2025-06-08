import 'package:get/get.dart';

class UserHistoryTapController extends GetxController {
  RxInt currentTab = 0.obs;

  void switchTab(int index) {
    currentTab.value = index;
  }
}