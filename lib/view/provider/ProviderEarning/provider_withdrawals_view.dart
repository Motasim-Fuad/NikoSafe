import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/providerEarningDataController/provider_withdrow_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class ProviderWithdrawalsView extends StatelessWidget {
  ProviderWithdrawalsView({super.key});

  final ProviderWithdrawalController controller = Get.put(ProviderWithdrawalController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Withdrawal History', style: TextStyle(color: AppColor.primaryTextColor)),
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.withdrawals.isEmpty) {
            return const Center(child: Text('No withdrawals found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.withdrawals.length,
            itemBuilder: (context, index) {
              final withdrawal = controller.withdrawals[index];
              return Card(
                color: AppColor.cardColor,
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(withdrawal.status),
                    child: Icon(
                      _getStatusIcon(withdrawal.status),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    withdrawal.formattedAmount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Region: ${withdrawal.region}',style: TextStyle(color: AppColor.secondaryTextColor),),
                      Text('Date: ${withdrawal.formattedDate}',style: TextStyle(color: AppColor.secondaryTextColor)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(withdrawal.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          withdrawal.status.toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(withdrawal.status),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}
