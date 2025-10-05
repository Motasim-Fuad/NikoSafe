import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/auth_repo/auth_repositry.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import '../../../utils/utils.dart';

class ResetOtpController extends GetxController {
  final _authRepository = AuthRepository();

  final List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  RxBool isLoading = false.obs;
  RxBool isResendLoading = false.obs;

  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
    print("Reset OTP Controller - Email: $email");
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

  Future<void> verifyOtpForResetPassword() async {
    final otp = getOtp();

    if (otp.length != 4) {
      Utils.toastMessage("Please enter 4-digit OTP");
      return;
    }

    if (email.isEmpty) {
      Utils.toastMessage("Email not found");
      return;
    }

    try {
      isLoading.value = true;

      final requestData = {
        "email": email,
        "otp": otp,
      };

      print("Verifying password reset OTP: $email");

      final response = await _authRepository.verifyPasswordResetOtp(requestData);

      print("OTP verification response: $response");

      if (response != null && response is Map && response['success'] == true) {
        Utils.successSnackBar("Success", response['message'] ?? "OTP verified successfully!");

        Get.toNamed(
            RouteName.resetPasswordView,
            arguments: {
              "email": email,
              "otp": otp
            }
        );
      } else {
        String errorMessage = response?['message'] ?? "Invalid OTP";
        Utils.errorSnackBar("Verification Failed", errorMessage);
      }

    } catch (error) {
      print("OTP verification error: $error");

      String errorMessage = "Something went wrong";
      if (error.toString().contains('401')) {
        errorMessage = "Invalid or expired OTP";
      } else if (error.toString().contains('No Internet')) {
        errorMessage = "No internet connection";
      }

      Utils.errorSnackBar("Error", errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (email.isEmpty) {
      Utils.toastMessage("Email not found");
      return;
    }

    try {
      isResendLoading.value = true;

      final requestData = {
        "email": email,
      };

      print("Resending password reset OTP to: $email");

      final response = await _authRepository.resendPasswordResetOtp(requestData);

      print("Resend OTP response: $response");

      if (response != null && response is Map && response['success'] == true) {
        Utils.successSnackBar("Success", "OTP sent to your email");

        for (var controller in controllers) {
          controller.clear();
        }
        if (focusNodes.isNotEmpty) {
          focusNodes[0].requestFocus();
        }
      } else {
        Utils.errorSnackBar("Error", "Failed to resend OTP");
      }

    } catch (error) {
      print("Resend OTP error: $error");
      Utils.errorSnackBar("Error", "Failed to resend OTP");
    } finally {
      isResendLoading.value = false;
    }
  }

  void clearOtp() {
    for (var controller in controllers) {
      controller.clear();
    }
    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
  }
}