// check_in/controller/check_in_controller.dart

import 'package:get/get.dart';
import 'package:nikosafe/Repositry/checkInRepo/checkInRepository.dart';
import 'package:nikosafe/models/chackin/checkInModel.dart';
import 'package:url_launcher/url_launcher.dart';


class UserCheckInController extends GetxController {
  final UserCheckInRepository _checkInRepository = UserCheckInRepository();

  Rx<UserCheckInModel?> location = Rx<UserCheckInModel?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> checkIn() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final position = await _checkInRepository.getCurrentPosition();
      final address = await _checkInRepository.getAddressFromLatLng(position);
      location.value = UserCheckInModel(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }




  //open google map

  void openInGoogleMaps() {
    final loc = location.value;
    if (loc == null) {
      Get.snackbar("Error", "No location found");
      return;
    }

    final latitude = loc.latitude;
    final longitude = loc.longitude;

    final Uri gmapUri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    launchUrl(gmapUri, mode: LaunchMode.externalApplication).catchError((e) {
      Get.snackbar("Failed", "Could not open Google Maps");
    });
  }
}
