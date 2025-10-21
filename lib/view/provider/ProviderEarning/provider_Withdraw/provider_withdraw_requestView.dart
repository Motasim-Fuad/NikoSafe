import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/providerEarningDataController/provider_withdrow_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class ProviderWithdrawRequestView extends StatelessWidget {
  ProviderWithdrawRequestView({super.key});

  final ProviderWithdrawalController controller = Get.put(ProviderWithdrawalController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Withdraw Request",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          centerTitle: true,
          leading: CustomBackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                label: "Amount",
                focusNode: controller.amountFocus,
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(controller.regionFocus);
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: controller.regionController,
                label: "Region",
                maxLines: 5,
                minLines: 3,
                focusNode: controller.regionFocus,
              ),
              const SizedBox(height: 20),
              Obx(() => RoundButton(
                width: double.infinity,
                title: "Submit Request",
                loading: controller.isSubmitting.value,
                onPress: controller.submitWithdrawalRequest,
              )),
            ],
          ),
        ),
      ),
    );
  }
}