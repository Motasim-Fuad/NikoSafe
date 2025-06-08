import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/User/UserProfile/Screen/user_Settings/change_password/widgets/password_widgets.dart';

class UserChangePasswordView extends StatelessWidget {
  UserChangePasswordView({super.key});

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
   final TextEditingController confirmNewPasswordController = TextEditingController();


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
          title: Text("Change Password",style: TextStyle(color: AppColor.primaryTextColor),),
          centerTitle: true,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              PasswordField(
                hint: "Current  Password",
                controller: currentPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16,),

              PasswordField(
                hint: "New  Password",
                controller: newPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16,),
              PasswordField(
                hint: "Confirm new password",
                controller: confirmNewPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20,),
              Spacer(),

              RoundButton(width: double.infinity,title: "Submit", onPress: (){


              }),

              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

}
