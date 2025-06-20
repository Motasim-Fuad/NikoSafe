import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/providerProfileController/Screen/BankDetailsViewModel/provider_Bank_DetailsViewModel.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../../../resource/Colors/app_colors.dart';
import '../../../../../resource/asseets/image_assets.dart';
import '../../../../../resource/compunents/customBackButton.dart';

class ProviderBankDetailsEditView extends StatelessWidget {
   ProviderBankDetailsEditView({super.key});
  final controller = Get.put(BankViewModel());
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Edit Your Bank Details",style: TextStyle(color: AppColor.primaryTextColor),),
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,


        ),

        body: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _input("Account Number", controller.accountNumber),
              _input("Routing Number", controller.routingNumber),
              _input("Bank Name", controller.bankName),
              _input("BankHolder Name", controller.bankHolderName),
              _input("Bank Address", controller.bankAddress),
              const SizedBox(height: 32),
             RoundButton(title: "Save", onPress: (){
               controller.updateData();
               Utils.successSnackBar("Bank Details", "Your Bank Details Data Edit Successfully Completed");
             },width: double.infinity,)
            ],
          ),
        ),
      ),
    );
  }


   Widget _input(String label, RxString obsController) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 16),
       child: Obx(() {
         return TextFormField(
           initialValue: obsController.value,
           onChanged: (val) => obsController.value = val,
           validator: (val) => val == null || val.isEmpty ? "Required" : null,
           style: const TextStyle(color: Colors.white),
           decoration: InputDecoration(
             labelText: label,
             labelStyle: const TextStyle(color: Colors.white),
             enabledBorder: const OutlineInputBorder(
               borderSide: BorderSide(color: Colors.white),
             ),
             focusedBorder: const OutlineInputBorder(
               borderSide: BorderSide(color: Colors.white),
             ),
           ),
         );
       }),
     );
   }



}
