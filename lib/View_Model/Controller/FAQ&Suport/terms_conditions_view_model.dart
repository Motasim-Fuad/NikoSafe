import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userProfile/privacy_tarms_aboutus.dart';
import 'package:nikosafe/models/FAQ&Suport/privacy_trms_about.dart';

class TermsConditionsController extends GetxController {
  final _repo = PrivacyTarmsAboutusRepo();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<PrivacyTrmsAbout?> termsConditions = Rx<PrivacyTrmsAbout?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchTermsConditions();
  }

  Future<void> fetchTermsConditions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repo.getTermsConditionsApi();

      if (response.success) {
        termsConditions.value = response;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load terms and conditions. Please try again.';
      print('Terms & Conditions Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    fetchTermsConditions();
  }
}