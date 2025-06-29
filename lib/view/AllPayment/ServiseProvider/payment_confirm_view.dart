import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/AllPayment/ServiseProvider/payment_details_view.dart';
import 'package:nikosafe/view/AllPayment/widgets/animation.dart';



class ServiseProviderPaymentConfirmationView extends StatelessWidget {
  const ServiseProviderPaymentConfirmationView({super.key});

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
              PulsingSvgIcon(),
              const SizedBox(height: 16),
              Text(
                'provider Payment Successful',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.limeColor
                ),
              ),
              const SizedBox(height: 40),
              RoundButton(
                title: 'See Details',
                onPress: () {
                  Get.to(ServiseProviderPaymentDetailsView());
                },
                width: 200,
                shadowColor: Colors.transparent,
                buttonColor: AppColor.iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}