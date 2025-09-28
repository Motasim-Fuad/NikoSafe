import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';

import '../../../View_Model/Controller/authentication/otp_controller.dart';
import '../../../utils/utils.dart';
import '../widgets/otp_input_filed.dart';

class OTPView extends StatelessWidget {
  OTPView({super.key});

  final OTPController controller = Get.put(OTPController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            color: Colors.white,
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: const Text(
            "Verify Email",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),

                  // Email display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Verification code sent to:",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Enter 4-Digit Code",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Please enter the 4-digit verification code\nsent to your email.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),

                  const SizedBox(height: 40),

                  // ✅ 4 OTP input fields (instead of 6)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return OTPInputField(
                        controller: controller.controllers[index],
                        focusNode: controller.focusNodes[index],
                        autoFocus: index == 0,
                        onChanged: (value) => controller.onOTPChange(index, value, context),
                      );
                    }),
                  ),

                  const SizedBox(height: 40),

                  // Verify Button
                  Obx(() => RoundButton(
                    title: controller.isLoading.value ? "Verifying..." : 'Verify Email',
                    loading: controller.isLoading.value,
                    onPress: controller.isLoading.value
                        ? () {} // Empty callback instead of null
                        : () {
                      controller.verifyOtp();
                      FocusScope.of(context).unfocus();
                    },
                  )),

                  const SizedBox(height: 24),

                  // Resend Code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive the code? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.resendOtp();
                        },
                        child: const Text(
                          "Resend",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}