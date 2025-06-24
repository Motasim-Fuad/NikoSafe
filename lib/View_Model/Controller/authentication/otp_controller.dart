import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/utils.dart';
import '../../../view/AllPayment/ServiseProvider/subscription_selection_view.dart';
import '../../../view/AllPayment/User/subscription_selection_view.dar.dart';
import '../../../view/AllPayment/vendor/vendor_sebscription_plan_view.dart';


class OTPController extends GetxController {
  final List<TextEditingController> controllers = List.generate(
    6,
        (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  RxBool isLoading = false.obs;
  late String email;
  RxString role = ''.obs;  // Use RxString for reactive role

  @override
  void onInit() {
    super.onInit();
    role.value = Get.arguments?['role']?.toLowerCase() ?? '';
    email = Get.arguments?['email'] ?? '';
    print("Received role in OTPController: ${role.value}");
  }

  void onOTPChange(int index, String value, BuildContext context) {
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      Utils.fieldFocusChange(context, focusNodes[index], focusNodes[index + 1]);
    }
    if (value.isEmpty && index > 0) {
      Utils.fieldFocusChange(context, focusNodes[index], focusNodes[index - 1]);
    }
  }

  String getOtp() => controllers.map((e) => e.text).join();

  Future<void> verifyOtp() async {
    final otp = getOtp();
    if (otp.length != 6) {
      Utils.tostMassage("Enter 6 digit OTP");
      return;
    }

    if (role.value.isEmpty) {
      Utils.tostMassage("Please select a role");
      return;
    }

    isLoading.value = true;

    try {
      // Simulate OTP verification delay
      await Future.delayed(const Duration(seconds: 2));

      // Save to SharedPreferences (simulate success)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isVerified', true);
      await prefs.setString('email', email);
      await prefs.setString('role', role.value);

      // Navigate to demo page after verification

      if(role.value=="user"){
        Get.to(() => UserSubscriptionSelectionView(),);
      }else if(role.value=="service_provider"){
        Get.to(() => ServiseProviderSubscriptionSelectionView(),);
      }else{
        Get.to(() => VendorSubscriptionSelectionView(),);
      }

    } catch (e) {
      Utils.tostMassage("OTP verification failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
