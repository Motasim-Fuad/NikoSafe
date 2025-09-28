import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/Authentication/verification/widgets/passwordField.dart';
import '../../../View_Model/Controller/authentication/password_controller.dart';

class PasswordView extends StatelessWidget {
  const PasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PasswordController controller = Get.put(PasswordController());

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
          title: const Text(
            "Set Password",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Email Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Setting password for:",
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

                  const SizedBox(height: 30),

                  const Text(
                    "Set Your Password",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Create a strong password to secure your account.",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 30),

                  // New Password Field
                  Obx(() => PasswordField(
                    controller: controller.newPasswordController,
                    label: "Enter new password",
                    isVisible: controller.newPasswordVisible.value,
                    errorText: controller.newPasswordError.value,
                    onToggleVisibility: () {
                      controller.toggleNewPasswordVisibility();
                    },
                    onChanged: (value) {
                      controller.validateNewPassword(value);
                    },
                  )),

                  const SizedBox(height: 20),

                  // Confirm Password Field
                  Obx(() => PasswordField(
                    controller: controller.confirmPasswordController,
                    label: "Confirm password",
                    isVisible: controller.confirmPasswordVisible.value,
                    errorText: controller.confirmPasswordError.value,
                    onToggleVisibility: () {
                      controller.toggleConfirmPasswordVisibility();
                    },
                    onChanged: (value) {
                      controller.validateConfirmPassword(value);
                    },
                  )),

                  const SizedBox(height: 20),

                  // Password Requirements
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password Requirements:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "• At least 8 characters long",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          "• Contains uppercase letter (A-Z)",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          "• Contains lowercase letter (a-z)",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          "• Contains at least one number",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Create Password Button
                  Obx(() => RoundButton(
                    width: double.infinity,
                    title: controller.loading.value ? "Creating..." : "Create Password",
                    loading: controller.loading.value,
                    onPress: controller.loading.value
                        ? () {}
                        : () {
                      controller.setPassword();
                      FocusScope.of(context).unfocus();
                    },
                  )),

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