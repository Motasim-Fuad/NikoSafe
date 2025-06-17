import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import '../../../../models/Provider/providerEarningData/providerEarningData.dart';


class ProviderEarningDataDetailsView extends StatelessWidget {
  const ProviderEarningDataDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderEarningDataModel? earning = Get.arguments;

    if (earning == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Earning Details')),
        body: const Center(child: Text('No data found')),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title:  Text('Earning Details',style: TextStyle(color: AppColor.primaryTextColor),),
          centerTitle: true,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,

        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  image: DecorationImage(
                    image: earning.avatarUrl != null && earning.avatarUrl!.isNotEmpty
                        ? AssetImage(earning.avatarUrl!) as ImageProvider
                        : AssetImage('assets/images/default_avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),



              const SizedBox(height: 20),
              _infoRow('Name', earning.name),
              _infoRow('Serial', earning.serial),
              _infoRow('Account No.', earning.accNumber),
              _infoRow('Date', earning.date),
              _infoRow('Amount', earning.amount),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColor.primaryTextColor)),
          Text(value, style: TextStyle(color: AppColor.primaryTextColor)),
        ],
      ),
    );
  }
}
