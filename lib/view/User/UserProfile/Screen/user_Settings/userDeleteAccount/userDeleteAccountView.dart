import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/utils/utils.dart';

import '../change_password/widgets/password_widgets.dart';

class UserDeleteAccauuntview extends StatelessWidget {
   UserDeleteAccauuntview({super.key});

  final emailController =TextEditingController();
  final passwordController =TextEditingController();

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
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          title: Text("Delete Account",style: TextStyle(color: AppColor.primaryTextColor),),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextField(
                controller: emailController,
                style: TextStyle(color: AppColor.primaryTextColor),

                decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: "Enter your email",
                      labelText: "Email",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle:  TextStyle(color: Colors.white),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      suffix: Icon(Icons.email_outlined,color: AppColor.primaryTextColor,),
                      border: OutlineInputBorder(),

                ),

              ),
            SizedBox(height: 20,),
              PasswordField(
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),


              Spacer(),
              RoundButton(width: double.infinity,title: "Delete Account",
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: AppColor.topLinear,
                          title: const Text("Are you sure?",style: TextStyle(color: Colors.white),),
                          content: const Text("This action will permanently delete your account.",style: TextStyle(color: Colors.white)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                              },
                              child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // Close dialog first
                                final email = emailController.text.trim();
                                final password = passwordController.text.trim();

                                if (email.isEmpty || password.isEmpty) {
                                  Utils.toastMessage("Email and password are required.");
                                } else {
                                  // TODO: Call delete account method here
                                  Utils.toastMessage("Account deletion logic goes here.");
                                }
                              },
                              child: const Text("Delete",style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  }


              ),

            ],
          ),
        ),
      ),
    );
  }
}
