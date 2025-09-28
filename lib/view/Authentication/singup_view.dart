import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/authentication/userAuthenticationController.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/utils/utils.dart';
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
                    return buildLoginForm(context, loginController); // ✅ Correct
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

  Widget buildLoginForm(BuildContext context, LoginAuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInput(
          controller.emailController,
          "Email",
          keyboardType: TextInputType.emailAddress,
          errorText: controller.emailError,
          focusNode: controller.emailFocus,
          nextFocusNode: controller.passwordFocus,
          textInputAction: TextInputAction.next,
        ),
        buildInput(
          controller.passwordController,
          "Password",
          isPassword: true,
          isPasswordVisible: controller.isPasswordVisible,
          errorText: controller.passwordError,
          focusNode: controller.passwordFocus,
          textInputAction: TextInputAction.done,
        ),

        const SizedBox(height: 10),

        // Removed role dropdown since backend handles it
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildRemember(controller),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteName.forgotPasswordView);
              },
              child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.red, fontSize: 15)
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Obx(() => RoundButton(
          loading: controller.loading.value,
          showLoader: true,
          title: controller.loading.value ? "Signing In..." : "Sign In",
          onPress: controller.loading.value
              ? () {}
              : () {
            controller.login();
            FocusScope.of(context).unfocus();
          },
          width: double.infinity,
        )),

        const SizedBox(height: 20),

        // Divider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: const BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.white)
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              "or",
              style: TextStyle(
                  color: AppColor.limeColor,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: const BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.white)
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Google Sign In
        GestureDetector(
          onTap: () {
            Utils.infoSnackBar("Coming Soon", "Google Sign In will be available soon");
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              color: AppColor.bottomLinear,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(ImageAssets.googleIcon, width: 30, height: 30),
                const SizedBox(width: 8),
                Text(
                  "Continue with Google",
                  style: TextStyle(color: AppColor.primaryTextColor),
                )
              ],
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Apple Sign In
        GestureDetector(
          onTap: () {
            Utils.infoSnackBar("Coming Soon", "Apple Sign In will be available soon");
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(20),
              color: AppColor.bottomLinear,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(ImageAssets.appleIcon, width: 30, height: 30),
                const SizedBox(width: 8),
                Text(
                  "Continue with Apple",
                  style: TextStyle(color: AppColor.primaryTextColor),
                )
              ],
            ),
          ),
        ),
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
                "Sign In",
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