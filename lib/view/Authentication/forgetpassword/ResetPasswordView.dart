import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/authentication/ResetPasswordController.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/Authentication/forgetpassword/wigeds/ResetPasswordField.dart';

class ResetPasswordView extends StatelessWidget {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  ResetPasswordView({Key? key}) : super(key: key);

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
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
              ),
              const SizedBox(height: 10),
              const Text(
                  "Set Your New Password",
                  style: TextStyle(fontSize: 16, color: Colors.white)
              ),
              const SizedBox(height: 6),
              const Text(
                "Create a new password to secure your account.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              Obx(() => ResetPasswordField(
                controller: controller.newPasswordController,
                label: "Enter new password",
                isVisible: controller.newPasswordVisible.value,
                onToggleVisibility: controller.toggleNewPasswordVisibility,
              )),

              const SizedBox(height: 20),

              Obx(() => ResetPasswordField(
                controller: controller.confirmPasswordController,
                label: "Confirm Password",
                isVisible: controller.confirmPasswordVisible.value,
                onToggleVisibility: controller.toggleConfirmPasswordVisibility,
              )),

              const SizedBox(height: 30),

              Obx(() => controller.isLoading.value
                  ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                ),
              )
                  : RoundButton(
                width: double.infinity,
                title: "Update Password",
                onPress: controller.updatePassword,
              )
              ),
            ],
          ),
        ),
      ),
    );
  }
}