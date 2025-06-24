import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/authentication/userAuthenticationController.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/Authentication/singup_provider_view.dart';
import 'package:nikosafe/view/Authentication/singup_user_view.dart';
import 'package:nikosafe/view/Authentication/singup_vendor_view.dart';
import 'package:nikosafe/view/Authentication/widgets/dropdowm/dropdown.dart';
import '../../View_Model/Controller/authentication/authentication_view_model.dart';

import '../../View_Model/Controller/authentication/login_authentication_controller.dart';
import '../../View_Model/Controller/authentication/servise_providerAuthenticationController.dart';
import '../../View_Model/Controller/authentication/vendorController.dart';
import '../../resource/compunents/customPopup_btn.dart';
import 'widgets/common_widget.dart';

class SignupView extends StatelessWidget {
  final MainAuthController mainController = Get.put(MainAuthController());
  final LoginAuthController loginController = Get.put(LoginAuthController());
  final UserAuthController userController = Get.put(UserAuthController());
  final VendorAuthController vendorController = Get.put(VendorAuthController());
  final ServiceProviderAuthController providerController = Get.put(ServiceProviderAuthController());


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Get Started Now",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Create an account or log in to explore about our app",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => Center(child: buildLoginSignUpToggle(mainController))),

                const SizedBox(height: 20),

                // Role toggle section
                Obx(() => !mainController.isLogin.value
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildTab("User", mainController.selectedRole.value == 'user', () {
                            mainController.setRole('user');
                          }),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: buildTab("Service Provider", mainController.selectedRole.value == 'service_provider', () {
                            mainController.setRole('service_provider');
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    buildTab("Hospitality Venue", mainController.selectedRole.value == 'vendor', () {
                      mainController.setRole('vendor');
                    }),
                  ],
                )
                    : const SizedBox()),

                const SizedBox(height: 20),

                // Dynamic Form
                Obx(() {
                  if (mainController.isLogin.value) {
                    return buildLoginForm(loginController); // ✅ Correct
                  } else if (mainController.selectedRole.value == 'user') {
                    return SignupUserView(controller: userController); // ✅ Correct controller
                  } else if (mainController.selectedRole.value == 'vendor') {
                    return SignupVendorView(); // ✅ Correct controller
                  } else {
                    return SignupProviderView(controller: providerController); // ✅ Correct controller
                  }
                }),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTab(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00D1B7) : const Color(0xFF2B3A42),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buildLoginForm(LoginAuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInput(
          controller.emailController,
          "Email",
          keyboardType: TextInputType.emailAddress,
          errorText: controller.emailError,
        ),
        buildInput(
          controller.passwordController,
          "Password",
          isPassword: true,
          isPasswordVisible: controller.isPasswordVisible,
          errorText: controller.passwordError,
        ),

        const SizedBox(height: 10),

        // Role Dropdown
        Obx(() => CustomPopupButton<String>(
          items: controller.roleOptions,
          selectedItem: controller.selectedRole.value,
          onSelected: (value) {
            controller.selectedRole.value = value;
          },
          hintText: "Select Role",
          customItemBuilder: (item) => Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.blue),
              const SizedBox(width: 8),
              Text(item.capitalizeFirst ?? item),
            ],
          ),
        )),



        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildRemember(controller),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteName.forgotPasswordView);
              },
              child: const Text("Forget Password ?", style: TextStyle(color: Colors.red, fontSize: 15)),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Obx(() => RoundButton(
          loading:  controller.loading.value,
          showLoader: true,

          title: "Login",
          onPress: () => controller.login(),
          width: double.infinity,
        )),
      ],
    );
  }

}

Widget buildLoginSignUpToggle(MainAuthController controller) {
  return Container(
    height: 40,
    width: 215,
    decoration: BoxDecoration(
      color: const Color(0x3300E6E0),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.switchToLogin();
            },
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: controller.isLogin.value ? const Color(0x9900E6E0) : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text(
                "Log In",
                style: TextStyle(
                  color: controller.isLogin.value ? const Color(0xFFFFFFFF) : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.switchToSignup();
            },
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: controller.isLogin.value ? Colors.transparent : const Color(0x9900E6E0),
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: controller.isLogin.value ? Colors.white : const Color(0xFFFFFFFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}