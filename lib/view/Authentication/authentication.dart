import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import '../../View_Model/Controller/authentication/authentication_view_model.dart';
import 'singup_view.dart';
// Make sure your AppColor class has the gradient

class AuthView extends StatelessWidget {
  final AuthViewModel controller = Get.put(AuthViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: AppColor.backGroundColor,
        ),
        child:  SignupView(),
      ),
    );
  }
}
