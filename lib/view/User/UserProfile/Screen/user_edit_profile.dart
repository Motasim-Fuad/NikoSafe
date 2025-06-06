import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class UserEditProfile extends StatelessWidget {
  const UserEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: CustomBackButton(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("User Edit Profile",style: TextStyle(color: AppColor.primaryTextColor),),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColor.backGroundColor),
        child: Padding(padding: EdgeInsets.all(16),child: Column(
          children: [

          ],
        ),),
      ),
    );
  }
}
