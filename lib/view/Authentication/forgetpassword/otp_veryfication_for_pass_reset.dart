import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';

import '../../../View_Model/Controller/authentication/_reset_otp_contoller.dart';
import '../widgets/otp_input_filed.dart';

class OtpVeryficationForPassResetView extends StatelessWidget {
  OtpVeryficationForPassResetView({super.key});

  final ResetOtpController controller = Get.put(ResetOtpController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          centerTitle: true,
          title: const Text(
            "Verify your email",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    "Enter OTP",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We have just sent you 4 digit code to ${controller.email}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) { // Fixed: Changed from 6 to 4
                      return OTPInputField(
                        controller: controller.controllers[index],
                        focusNode: controller.focusNodes[index],
                        autoFocus: index == 0,
                        onChanged: (value) =>
                            controller.onOTPChange(index, value, context),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Verify Button with loading state
                  Obx(() => controller.isLoading.value
                      ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                    ),
                  )
                      : RoundButton(
                    title: "Verify",
                    onPress: controller.verifyOtpForResetPassword,
                  )
                  ),

                  const SizedBox(height: 16),

                  // Resend OTP Button
                  Obx(() => TextButton(
                    onPressed: controller.isResendLoading.value
                        ? null
                        : controller.resendOtp,
                    child: controller.isResendLoading.value
                        ? const Text(
                      "Sending...",
                      style: TextStyle(color: Colors.grey),
                    )
                        : const Text.rich(
                      TextSpan(
                        text: "Didn't receive code? ",
                        children: [
                          TextSpan(
                            text: "Resend Code",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}