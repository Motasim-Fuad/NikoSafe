import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/Authentication/widgets/common_widget.dart';
import '../../View_Model/Controller/authentication/authentication_view_model.dart';

class SignupUserView extends StatelessWidget {
  final AuthViewModel controller;
  const SignupUserView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: SafeArea(
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInput(controller.nameController, "Full Name"),
              buildInput(controller.phoneController, "Mobile Number"),
              buildInput(controller.ageController, "Your Age"),
              buildInput(controller.weightController, "Your Weight"),
              buildInput(controller.sexController, "Your Sex"),
              buildInput(controller.emailController, "Email"),
              buildInput(
                controller.passwordController,
                "Password",
                isPassword: true,
                isPasswordVisible: controller.isPasswordVisible,
              ),

              const SizedBox(height: 10),
              buildTermsCheck(controller),
              const SizedBox(height: 20),
              Obx(() => controller.loading.value
                  ? const Center(child: CircularProgressIndicator())
                  :RoundButton(title: "Verify Email", width: double.infinity,shadowColor: AppColor.buttonShadeColor,onPress: (){
                    controller.signup();
              }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
// buildSubmitButton("Verify Email", controller.signup))