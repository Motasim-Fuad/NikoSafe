import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/providerProfileController/Screen/withdrawCompleteViewModel/withdrawCompleteController.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

import '../../../../../resource/compunents/elevatedbutton.dart';

class ProviderWithDrawCompleteView extends StatelessWidget {
  final controller = Get.put(WithdrawCompleteViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading:        CustomBackButton(),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _topCard(context),
              const SizedBox(height: 16),
              _tableHeader(),
              Expanded(child: _withdrawList()),
            ],
          );
        }),
      ),
    );
  }

  Widget _topCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child:
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Optional: for background color
          ),
          child:
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.topLinear,

                ),
                child:SvgPicture.asset(ImageAssets.withdrowimg,fit: BoxFit.cover,) ,
              ),
              Positioned(

                top: 50,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [





                    Text(
                      "Your Withdraw History",
                      style: TextStyle(color: AppColor.primaryTextColor,fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _tableHeader() {
    return Container(
      color: Colors.teal.shade900,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(child: Text("Date", style: TextStyle(color: Colors.white))),
          Expanded(
            child: Text("Amount", style: TextStyle(color: Colors.white)),
          ),
          Expanded(
            child: Text("Status", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _withdrawList() {
    return Obx(
      () => ListView.builder(
        itemCount: controller.withdrawList.length,
        itemBuilder: (context, index) {
          final item = controller.withdrawList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.date,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.amount,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.status,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
