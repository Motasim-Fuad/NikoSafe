import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/view/Authentication/forgetpassword/wigeds/forget_passwoed_input_widget.dart';

import '../../../utils/utils.dart';


class ForgetpasswordView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D2C35),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      body: Padding(

        padding: const EdgeInsets.all(20),

        child: ListView(

          children: [
            const Text("Forgot Password", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            const Text("No worries!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            const Text(
              "Enter your registered email address or mobile number and we’ll send instructions to reset your password.",
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 30),
            ForgotPasswordInputWidget(
              controller: emailController,
                onSubmit: () {
                  final email = emailController.text.trim();
                  if (email.isEmpty) {
                    Utils.tostMassage("Please enter your email.");
                    return;
                  }else{
                    print("forgot pass enter email :$email");
                    Get.toNamed(RouteName.otpVeryficationForPassResetView, arguments: {"email": email});
                  }

                  // TODO: Call API to send OTP to the email, handle success/failure.
                  // If success:

                }

            ),
          ],
        ),
      ),
    );
  }
}
