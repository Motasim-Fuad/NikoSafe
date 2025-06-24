import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/utils/utils.dart';

class ProviderSendQuoteView extends StatelessWidget {
  const ProviderSendQuoteView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController taskTitle =TextEditingController();
    final TextEditingController taskDescription =TextEditingController();
    final TextEditingController taskPrice =TextEditingController();
    return Container(

      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: CustomBackButton(),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("Send Quote",style: TextStyle(color: AppColor.primaryTextColor),),
        ),
        body: Container(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            children: [
              CustomTextField(controller: taskTitle,label: "Task Title",),
              CustomTextField(controller: taskDescription,label: "Task Description",),
              CustomTextField(controller: taskPrice,keyboardType: TextInputType.number,label: "Task Price",),

              Spacer(),
              RoundButton(width: double.infinity,title: "Send", onPress: (){
                //TODO
                Utils.successSnackBar("Quote", "Quote Send Successfully");
                taskTitle.clear();
                taskDescription.clear();
                taskPrice.clear();

              }),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
