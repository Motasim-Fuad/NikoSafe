import 'package:get/get.dart';

class AuthTabController extends GetxController {
  var selectedTab = 0.obs; // 0: Login, 1: Signup
  var selectedRole = 'user'.obs; // 'user' or 'service_provider'
}
