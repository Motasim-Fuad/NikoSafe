import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/Authentication/singup_provider_view.dart';
import 'package:nikosafe/view/Authentication/singup_user_view.dart';
import '../../View_Model/Controller/authentication/authentication_view_model.dart';
import 'widgets/common_widget.dart';

class SignupView extends StatelessWidget {
  final AuthViewModel controller = Get.put(AuthViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor:Colors.transparent,
        body: SafeArea(
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text("Get Started Now", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text("Create an account or log in to explore about our app", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 20),

                  Center(child: buildLoginSignUpToggle(controller)),

                  const SizedBox(height: 20),

                  // Toggle Role
                  if (!controller.isLogin.value)
                    Column(
                      children: [
                        const Text("Choose Your Role",style: TextStyle(color: AppColor.primaryTextColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildTab("User", controller.isUser.value, () {
                              controller.isUser.value = true;
                              controller.clearProviderSignupFields(); // Clear provider fields when switching to user
                            }),
                            const SizedBox(width: 10),
                            buildTab("Service Provider", !controller.isUser.value, () {
                              controller.isUser.value = false;
                              controller.clearUserSignupFields(); // Clear user fields when switching to provider
                            }),
                          ],
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  controller.isLogin.value
                      ? buildLoginForm(controller)
                      : controller.isUser.value
                      ? SignupUserView(controller: controller)
                      : SignupProviderView(controller: controller),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildTab(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF00D1B7) : const Color(0xFF2B3A42),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget buildLoginForm(AuthViewModel controller) {
    return Column(
      children: [
        buildInput(
          controller.loginEmailController, // Use login-specific controller
          "Email",
          keyboardType: TextInputType.emailAddress,
          errorText: controller.loginEmailError, // Use login-specific error
        ),
        buildInput(
          controller.loginPasswordController, // Use login-specific controller
          "Password",
          isPassword: true,
          isPasswordVisible: controller.isPasswordVisible,
          errorText: controller.loginPasswordError, // Use login-specific error
        ),

        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRemember(controller), // Assuming remember me is common

              GestureDetector(
                onTap: (){
                  Get.toNamed(RouteName.forgotPasswordView);
                },
                child: Text("Forget Password ?",style: TextStyle(color: Colors.red,fontSize: 15),),
              )
            ],
          ),
        ),

        const SizedBox(height: 20),
        Obx(() => controller.loading.value
            ? const CircularProgressIndicator()
            : RoundButton(
          title: "Login",
          onPress: (){
            controller.login();

            }, // Calls the central login method
          width: double.infinity,
        ),
        ),
      ],
    );
  }
}

// buildLoginSignUpToggle remains unchanged from your original code
Widget buildLoginSignUpToggle(AuthViewModel controller) {
  return Container(
    height: 40,
    width: 215,
    decoration: BoxDecoration(
      color: const Color(0x3300E6E0), // Outer background (cyan)
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.isLogin.value = true;
              controller.clearUserSignupFields();    // Clear signup fields when switching to login
              controller.clearProviderSignupFields();
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
              controller.isLogin.value = false;
              controller.clearLoginFields(); // Clear login fields when switching to signup
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