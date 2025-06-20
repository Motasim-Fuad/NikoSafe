import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/utils/utils.dart';

class ProviderWithdrawRequestView extends StatelessWidget {
  ProviderWithdrawRequestView({super.key});

  final TextEditingController amountText = TextEditingController();
  final TextEditingController regionText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // ✅ Important
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Optional for gradient header
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
          padding: const EdgeInsets.all(16), // ✅ Corrected padding
          child: Column(
            children: [
              CustomTextField(controller: amountText,keyboardType: TextInputType.number,),
              const SizedBox(height: 10),
              CustomTextField(controller: regionText),
              const SizedBox(height: 10),
              RoundButton(
                width: double.infinity,
                title: "Withdraw Request",
                onPress: () {
                  Utils.successSnackBar("Withdraw Request", "Your withdraw request sent successfully");

                  amountText.clear();
                  regionText.clear();

                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
