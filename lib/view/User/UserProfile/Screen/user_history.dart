import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class UserHistory extends StatelessWidget {
  const UserHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("History",style: TextStyle(color: AppColor.primaryTextColor),),
        ),
        body: Padding(padding: EdgeInsets.all(16),child: Column(
          children: [
          Text("history")
          ],
        ),),
      ),
    );
  }
}
