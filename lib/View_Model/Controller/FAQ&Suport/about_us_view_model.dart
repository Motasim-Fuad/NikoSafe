import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userProfile/privacy_tarms_aboutus.dart';
import 'package:nikosafe/models/FAQ&Suport/privacy_trms_about.dart';

class AboutUsController extends GetxController {
  final _repo = PrivacyTarmsAboutusRepo();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<PrivacyTrmsAbout?> aboutUs = Rx<PrivacyTrmsAbout?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchAboutUs();
  }

  Future<void> fetchAboutUs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repo.getAboutUsApi();

      if (response.success) {
        aboutUs.value = response;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load about us information. Please try again.';
      print('About Us Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    fetchAboutUs();
  }
}