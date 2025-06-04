// user_home_tab_controller.dart
import 'package:get/get.dart';

class UserHomeTabController extends GetxController {
  RxInt currentTab = 0.obs;

  void switchTab(int index) {
    currentTab.value = index;
  }
}
