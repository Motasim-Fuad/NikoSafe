import 'package:get/get.dart';
import 'package:nikosafe/models/myProfileModel/my_profile_model.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileController extends GetxController {
  var profile = MyProfileModel(
    name: "Lukas Wagner",
    points: 190,
    profileImage: ImageAssets.userHome_userProfile,
  ).obs;

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Clear token and other user data
      await prefs.clear();

      // Optionally reset observable profile if needed
      // profile.value = MyProfileModel(
      //   name: "",
      //   points: 0,
      //   profileImage: ImageAssets.userHome_userProfile,
      // );

      // Navigate to login screen
      Get.offAllNamed(RouteName.authView); // Replace with your login route
    } catch (e) {
      Get.snackbar("Error", "Logout failed: $e");
    }
  }
}
