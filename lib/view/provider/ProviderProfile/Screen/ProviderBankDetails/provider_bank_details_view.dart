import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import '../../../../../View_Model/Controller/provider/providerProfileController/Screen/BankDetailsViewModel/provider_Bank_DetailsViewModel.dart';
class ProviderBankDetailsView extends StatelessWidget {
   ProviderBankDetailsView({super.key});
  final controller = Get.put(BankViewModel());
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Bank Details",style: TextStyle(color: AppColor.primaryTextColor),),
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: (){
                Get.toNamed(RouteName.providerBankDetailsEditView);
                print("object");
              },
              child: CircleAvatar(
                backgroundColor: AppColor.iconColor,
                child: SvgPicture.asset(ImageAssets.profile_edit,),
              ),
            ),
            SizedBox(width: 8,),
          ],
        ),

        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = controller.bankDetails.value;
          if (data == null) {
            return const Center(child: Text("No data found", style: TextStyle(color: Colors.white)));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _readonlyField("Account Number", data.accountNumber),
              _readonlyField("Routing Number", data.routingNumber),
              _readonlyField("Bank Name", data.bankName),
              _readonlyField("BankHolder Name", data.bankHolderName),
              _readonlyField("Bank Address", data.bankAddress),
            ],
          );
        }),
      ),
    );
  }


   Widget _readonlyField(String label, String value) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 16),
       child: TextFormField(
         readOnly: true,
         initialValue: value,
         style: const TextStyle(color: Colors.white),
         decoration: InputDecoration(
           labelText: label,
           labelStyle: const TextStyle(color: Colors.white),
           enabledBorder: OutlineInputBorder(
             borderSide: BorderSide(color: Colors.white),
           ),
           focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(color: Colors.white),
           ),
         ),
       ),
     );
   }



}
