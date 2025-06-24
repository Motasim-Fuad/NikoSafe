import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/resource/compunents/elevatedbutton.dart';
import 'package:nikosafe/view/AllPayment/ServiseProvider/servise_provider_verification_view.dart';


import '../../../View_Model/Controller/AllPayment/serviseProviderController/servise_provider_payment_controller.dart';
import '../../../resource/asseets/image_assets.dart'; // Make sure this is your asset import

class ServiseProviderPaymentDetailsView extends StatelessWidget {
  const ServiseProviderPaymentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiseProviderPaymentController());

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Provider Payment Details',
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Main card container
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.iconColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 60), // Space for icon
                        const Text(
                          'Payment Total',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          '\$${controller.paymentDetails.value.amount}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildDetailRow('Date', '31 Dec 2023'),
                        _buildDetailRow('Transaction ID', '#${controller.paymentDetails.value.transactionId}'),
                        _buildDetailRow('Account', controller.paymentDetails.value.accountName),
                        const Divider(height: 40, color: Colors.grey),
                        _buildDetailRow('Total Payment', '\$${controller.paymentDetails.value.amount}'),
                        _buildDetailRow('Total', '\$${controller.paymentDetails.value.amount}', isBold: true),
                        const SizedBox(height: 24),
                        CustomElevatedButton(
                          text: 'Get PDF Receipt',
                          onPressed: () {
                            controller.generateAndDownloadPdfReceipt();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Success icon on top of card
                  SvgPicture.asset(
                    ImageAssets.paymentSuccessIcon,
                    height: 100,
                  ),
                ],
              ),

              Spacer(),
              SizedBox(height: 10,),
              RoundButton(
                width: double.infinity,
                title: 'Next',
                onPress: () {
                  Get.to(ServiseProviderVerificationView());
                },
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
