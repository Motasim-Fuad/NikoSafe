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
  final  amountFocus = FocusNode();
  final  regionFocus = FocusNode();

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
              CustomTextField(controller: amountText,keyboardType: TextInputType.number,label: "Amount",focusNode: amountFocus,onSubmitted: (value) {
                FocusScope.of(context).requestFocus(regionFocus);
              },),
              const SizedBox(height: 10),
              CustomTextField(controller: regionText ,label: "Region",maxLines: 5,minLines: 3,focusNode: regionFocus,),
              const SizedBox(height: 20),
              RoundButton(
                width: double.infinity,
                title: "Withdraw Request",
                onPress: () {
                  Utils.successSnackBar("Withdraw Request", "Your withdraw request sent successfully");

                  amountText.clear();
                  regionText.clear();
                  FocusScope.of(context).unfocus();

                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
