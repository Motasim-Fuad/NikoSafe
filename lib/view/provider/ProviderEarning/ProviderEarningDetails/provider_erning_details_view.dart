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
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Earning Details', style: TextStyle(color: AppColor.primaryTextColor)),
          centerTitle: true,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Transaction ID', earning.id.toString()),
                Divider(),
                _buildDetailRow('Customer Name', earning.customerName),
                Divider(),
                _buildDetailRow('Task Title', earning.taskTitle),
                Divider(),
                _buildDetailRow('Date', earning.formattedDate),
                Divider(),
                _buildDetailRow('Amount', earning.formattedAmount, isAmount: true),
                Divider(),
                _buildDetailRow('Status', earning.status.toUpperCase(), isStatus: true),
                Divider(),
                _buildDetailRow('Transaction Type', earning.transactionType),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false, bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColor.primaryTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isAmount
                  ? Colors.green
                  : isStatus
                  ? (value == 'COMPLETED' ? Colors.green : Colors.orange)
                  : AppColor.primaryTextColor,
              fontWeight: isAmount || isStatus ? FontWeight.bold : FontWeight.normal,
              fontSize: isAmount ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

