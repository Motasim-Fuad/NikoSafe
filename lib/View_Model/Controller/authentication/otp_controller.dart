import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/utils.dart';
import '../../../Repositry/auth_repo/auth_repositry.dart';

class OTPController extends GetxController {
  final _authRepository = AuthRepository();

  // ✅ 4 digit OTP controllers (not 6)
  final List<TextEditingController> controllers = List.generate(
    4, // Changed from 6 to 4
        (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  RxBool isLoading = false.obs;
  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
    print("📧 Email for OTP verification: $email");
  }

  // @override
  // void onClose() {
  //   // Clean up controllers and focus nodes
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

  Future<void> verifyOtp() async {
    final otp = getOtp();

    // ✅ Check for 4 digit OTP
    if (otp.length != 4) {
      Utils.tostMassage("Please enter 4-digit OTP");
      return;
    }

    if (email.isEmpty) {
      Utils.tostMassage("Email not found");
      return;
    }

    isLoading.value = true;

    try {
      // ✅ Prepare data for OTP verification API
      final requestData = {
        "email": email,
        "otp": otp,
      };

      print("🔐 Verifying OTP:");
      print("Email: $email");
      print("OTP: $otp");

      // ✅ Call your verify email API
      final response = await _authRepository.verifyEmailOtp(requestData);

      print("📡 OTP Verification Response: $response");

      if (response != null && response is Map) {
        bool isSuccess = response['success'] == true;

        if (isSuccess) {
          final prefs = await SharedPreferences.getInstance();

          // ✅ Save verification status
          await prefs.setBool('isVerified', true);
          await prefs.setString('verified_email', email);

          // ✅ If backend returns tokens, save them
          if (response['data']?['token'] != null) {
            await prefs.setString('auth_token', response['data']['token']);
          }

          if (response['data']?['refreshToken'] != null) {
            await prefs.setString('refresh_token', response['data']['refreshToken']);
          }

          Utils.successSnackBar("Success",
              response['message'] ?? "Email verified successfully!");


          Get.toNamed(
            RouteName.passwordView,
            arguments: {'email': email},
          );

        } else {
          String errorMessage = "OTP verification failed";
          if (response['message'] != null) {
            errorMessage = response['message'].toString();
          }
          Utils.errorSnackBar("Verification Failed", errorMessage);
        }
      } else {
        Utils.errorSnackBar("Error", "Invalid response from server");
      }

    } catch (e) {
      print("❌ OTP Verification Error: $e");

      String errorMessage = "Something went wrong";

      if (e.toString().contains('400')) {
        errorMessage = "Invalid OTP. Please try again.";
      } else if (e.toString().contains('401')) {
        errorMessage = "OTP expired. Please request a new one.";
      } else if (e.toString().contains('422')) {
        errorMessage = "Invalid email or OTP format.";
      } else if (e.toString().contains('No Internet')) {
        errorMessage = "No internet connection.";
      } else if (e.toString().contains('timeout')) {
        errorMessage = "Request timeout. Please try again.";
      }

      Utils.errorSnackBar("Error", errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Resend OTP functionality
  Future<void> resendOtp() async {
    if (email.isEmpty) {
      Utils.tostMassage("Email not found");
      return;
    }

    try {
      isLoading.value = true;

      final requestData = {"email": email};

      // ✅ Call resend OTP API (you might need to create this in repository)
      final response = await _authRepository.resendOtp(requestData);

      if (response != null && response is Map && response['success'] == true) {
        Utils.successSnackBar("Success", "OTP sent to your email");
        clearOtp(); // Clear current OTP input
      } else {
        Utils.errorSnackBar("Error", "Failed to resend OTP");
      }

    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to resend OTP");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Clear OTP fields
  void clearOtp() {
    for (var controller in controllers) {
      controller.clear();
    }
    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
  }


}