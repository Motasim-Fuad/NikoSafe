import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import '../../../utils/utils.dart';

class ResetOtpController extends GetxController {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  RxBool isLoading = false.obs;

  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
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

  void veryfyOtpForResetPassword() {
    final otp = getOtp();
    if (otp.length != 6) {
      Utils.tostMassage("Enter 6 digit OTP");
      return;
    }
    print(email);
    // Get.toNamed(RouteName.resetPasswordView, arguments: {"email": email});
    Get.toNamed(RouteName.resetPasswordView);
  }
}
