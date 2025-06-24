import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'payment_details_view.dart';


class VendorPaymentConfirmationView extends StatelessWidget {
  const VendorPaymentConfirmationView({super.key});

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
              SvgPicture.asset(ImageAssets.paymentSuccessIcon,height: 100,),
              const SizedBox(height: 16),
              Text(
                'Vendor Payment Successful',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryTextColor
                ),
              ),
              const SizedBox(height: 40),
              RoundButton(
                title: 'See Details',
                onPress: () {
                  Get.to(VendorPaymentDetailsView());
                },
                width: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}