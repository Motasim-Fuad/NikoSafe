import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userProfile/privacy_tarms_aboutus.dart';
import 'package:nikosafe/models/FAQ&Suport/privacy_trms_about.dart';

class PrivacyPolicyController extends GetxController {
  final _repo = PrivacyTarmsAboutusRepo();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<PrivacyTrmsAbout?> privacyPolicy = Rx<PrivacyTrmsAbout?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repo.getPrivacyPolicyApi();

      if (response.success) {
        privacyPolicy.value = response;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load privacy policy. Please try again.';
      print('Privacy Policy Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    fetchPrivacyPolicy();
  }
}