import 'dart:async';
import 'package:get/get.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../resource/App_routes/routes_name.dart';

class SplashServices {
  void isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role');

    print("💾 Token: $token");
    print("💾 Role: $role");

    Timer(const Duration(seconds: 3), () {
      if (token == null || token.isEmpty) {
        Get.offNamed(RouteName.authView);
      } else {
        if (role == 'user') {
          Get.offNamed(RouteName.userBottomNavView);
        } else if (role == 'sub_admin') {
          Get.offNamed(RouteName.providerBtmNavView);
        } else if (role == 'vendor') {
         // Get.offNamed(RouteName.vendorBottomNavView); // ✅ Create route

          Utils.successSnackBar("vendor", "vendor page");
        } else {
          Get.snackbar("Error", "Unknown role: $role");
          Get.offNamed(RouteName.authView);
        }
      }
    });

  }
}
