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

    final  taskTitleFocus =FocusNode();
    final  taskDescriptionFocus =FocusNode();
    final  taskPriceFocus =FocusNode();
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
              CustomTextField(controller: taskTitle,label: "Task Title",focusNode: taskTitleFocus,onSubmitted: (value) {
                FocusScope.of(context).requestFocus(taskDescriptionFocus);
              },),
              SizedBox(height: 10,),
              CustomTextField(controller: taskDescription,label: "Task Description",minLines: 4,maxLines: 5,focusNode: taskDescriptionFocus,onSubmitted: (value) {
                FocusScope.of(context).requestFocus(taskPriceFocus);
              },),
              SizedBox(height: 10,),
              CustomTextField(controller: taskPrice,keyboardType: TextInputType.number,label: "Task Price",focusNode: taskPriceFocus,),

              Spacer(),
              RoundButton(width: double.infinity,title: "Send", onPress: (){
                //TODO
                Utils.successSnackBar("Quote", "Quote Send Successfully");
                FocusScope.of(context).unfocus();
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
