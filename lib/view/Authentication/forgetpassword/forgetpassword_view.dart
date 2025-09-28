import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/authentication/forgot_password_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/Authentication/forgetpassword/wigeds/forget_passwoed_input_widget.dart';


class ForgetpasswordView extends StatelessWidget {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

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
          leading: BackButton(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const Text(
                  "Forgot Password",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  )
              ),
              const SizedBox(height: 10),
              const Text(
                  "No worries!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  )
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your registered email address or mobile number and we'll send instructions to reset your password.",
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 30),

              // Show loading indicator when API is being called
              Obx(() => controller.isLoading.value
                  ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
              )
                  : ForgotPasswordInputWidget(
                controller: controller.emailController,
                onSubmit: controller.sendPasswordResetRequest,
              )
              ),
            ],
          ),
        ),
      ),
    );
  }
}