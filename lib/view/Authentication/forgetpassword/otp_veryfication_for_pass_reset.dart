import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';

import '../../../View_Model/Controller/authentication/_reset_otp_contoller.dart';

import '../widgets/otp_input_filed.dart';



class OtpVeryficationForPassResetView extends StatelessWidget {
  OtpVeryficationForPassResetView({super.key});

   final ResetOtpController controller = Get.put(ResetOtpController());

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
          centerTitle: true,
          title: const Text(
            "Verify your email",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    "Enter OTP",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "We have just sent you 6 digit code via your email.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return OTPInputField(
                        controller: controller.controllers[index],
                        focusNode: controller.focusNodes[index],
                        autoFocus: index == 0,
                        onChanged: (value) =>
                            controller.onOTPChange(index, value, context),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  RoundButton(title: "Verify", onPress: (){
                    controller.veryfyOtpForResetPassword();
                  }),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Resend OTP logic here
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Didn't receive code? ",
                        children: [
                          TextSpan(
                            text: "Resend Code",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }



}


//
// void resetPassword() async {
//   final email = Get.arguments?['email'];
//   final newPass = newPasswordController.text.trim();
//   final confirmPass = confirmPasswordController.text.trim();
//
//   if (newPass.isEmpty || confirmPass.isEmpty) {
//     Utils.tostMassage("Please fill all fields");
//     return;
//   }
//
//   if (newPass != confirmPass) {
//     Utils.tostMassage("Passwords do not match");
//     return;
//   }
//
//   try {
//     final response = await NetworkApiServices().postApi(
//       {
//         "email": email,
//         "newPassword": newPass,
//       },
//       "http://115.127.156.131:2001/api/v1/auth/reset-password",
//     );
//
//     if (response['success']) {
//       Utils.snackBar("Success", "Password Reset Successfully");
//       Get.offAllNamed(RouteName.loginView);
//     } else {
//       Utils.snackBar("Error", response['message']);
//     }
//   } catch (e) {
//     Utils.snackBar("Error", e.toString());
//   }
// }