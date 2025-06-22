import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/authentication/authentication_view_model.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../View_Model/Controller/authentication/vendorController.dart';

import '../../resource/compunents/RoundButton.dart';
import '../../resource/Colors/app_colors.dart';
import 'widgets/common_widget.dart';

class SignupVendorView extends StatelessWidget {
  final VendorSignupViewModel controller = Get.put(VendorSignupViewModel());
  final AuthViewModel controllermmm = Get.put(AuthViewModel());


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildInput(controller.nameController, "Business Name", errorText: controller.nameError),
          buildInput(controller.emailController, "Email", errorText: controller.emailError),
          buildInput(controller.phoneController, "Phone", errorText: controller.phoneError),
          buildInput(controller.passwordController, "Password",
              isPassword: true,
              isPasswordVisible: controller.isPasswordVisible,
              errorText: controller.passwordError),
          buildInput(controller.locationController, "Business Address", errorText: controller.locationError),

          buildUploadBoxforvendor(controller),
          const SizedBox(height: 10),
          // buildTermsCheck(controllermmm.agreeTerms as AuthViewModel  ),
          const SizedBox(height: 20),

          Obx(() => controller.loading.value
              ? const CircularProgressIndicator()
              : RoundButton(
            title: "Verify Email",
            width: double.infinity,
            shadowColor: AppColor.buttonShadeColor,
            onPress: () {

              if (controller.validateAll()) {
               Utils.successSnackBar("Success", "Vendor form is valid");

              }
            },
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
