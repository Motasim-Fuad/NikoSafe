import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/auth_repo/auth_repositry.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import '../../../utils/utils.dart';

class ResetOtpController extends GetxController {
  final _authRepository = AuthRepository();

  final List<TextEditingController> controllers = List.generate(
    4, // Changed from 6 to 4 as per your requirement
        (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  RxBool isLoading = false.obs;
  RxBool isResendLoading = false.obs;

  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
    print("Reset OTP Controller initialized with email: $email");
  }

  // @override
  // void onClose() {
  //   for (var controller in controllers) {
  //     controller.dispose();
  //   }
  //   for (var focusNode in focusNodes) {
  //     focusNode.dispose();
  //   }
  //   super.onClose();
  // }

  void onOTPChange(int index, String value, BuildContext context) {
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      Utils.fieldFocusChange(context, focusNodes[index], focusNodes[index + 1]);
    }
    if (value.isEmpty && index > 0) {
      Utils.fieldFocusChange(context, focusNodes[index], focusNodes[index - 1]);
    }
  }

  String getOtp() => controllers.map((e) => e.text).join();

  // ✅ NEW: API integration for OTP verification
  Future<void> verifyOtpForResetPassword() async {
    final otp = getOtp();
    if (otp.length != 4) {
      Utils.toastMessage("Enter 4 digit OTP");
      return;
    }

    try {
      isLoading.value = true;

      final requestData = {
        "email": email,
        "otp": otp,
      };

      print("Verifying password reset OTP: $requestData");

      final response = await _authRepository.verifyPasswordResetOtp(requestData);

      print("Password reset OTP verification response: $response");

      if (response['success'] == true) {
        Utils.toastMessage(response['message'] ?? "OTP verified successfully!");

        // Navigate to reset password screen with email and OTP
        Get.toNamed(
            RouteName.resetPasswordView,
            arguments: {
              "email": email,
              "otp": otp
            }
        );
      } else {
        Utils.toastMessage(response['message'] ?? "Invalid OTP. Please try again.");
      }

    } catch (error) {
      print("Password reset OTP verification error: $error");
      Utils.toastMessage("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ NEW: Resend OTP functionality
  Future<void> resendOtp() async {
    try {
      isResendLoading.value = true;

      final requestData = {
        "email": email,
      };

      print("Resending password reset OTP to: $email");

      final response = await _authRepository.resendPasswordResetOtp(requestData);

      print("Resend password reset OTP response: $response");

      if (response['success'] == true) {
        Utils.toastMessage(response['message'] ?? "OTP sent successfully!");

        // Clear previous OTP
        for (var controller in controllers) {
          controller.clear();
        }

        // Focus on first field
        if (focusNodes.isNotEmpty) {
          focusNodes[0].requestFocus();
        }
      } else {
        Utils.toastMessage(response['message'] ?? "Failed to resend OTP");
      }

    } catch (error) {
      print("Resend password reset OTP error: $error");
      Utils.toastMessage("Something went wrong. Please try again.");
    } finally {
      isResendLoading.value = false;
    }
  }
}