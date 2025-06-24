import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/AllPayment/User/payment_details_view.dart';

import '../widgets/animation.dart';


class UserPaymentConfirmationView extends StatelessWidget {
  const UserPaymentConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 1,),

              const PulsingSvgIcon(),


              const SizedBox(height: 16),
               Text(
                'user Payment Successful',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.limeColor
                ),
              ),

              Spacer(flex: 1,),
              RoundButton(
                title: 'See Details',
                onPress: () {
                  Get.to(UserPaymentDetailsView());
                },
                width: 200,
                shadowColor: Colors.transparent,
                buttonColor: AppColor.iconColor,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}