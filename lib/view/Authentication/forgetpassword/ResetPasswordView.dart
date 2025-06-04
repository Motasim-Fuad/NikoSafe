import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/view/Authentication/forgetpassword/wigeds/ResetPasswordField.dart';


class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

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
            const Text("Reset Password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            const Text("Set Your New Password",
                style: TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 6),
            const Text(
              "Create a new password to secure your account.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            ResetPasswordField(
              controller: newPasswordController,
              label: "Enter new password",
              isVisible: newPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  newPasswordVisible = !newPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 20),

            ResetPasswordField(
              controller: confirmPasswordController,
              label: "Confirm Password",
              isVisible: confirmPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  confirmPasswordVisible = !confirmPasswordVisible;
                });
              },
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // Validate and process new password

                Get.toNamed(RouteName.authView);
              },
              child: const Text("Update Password", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
