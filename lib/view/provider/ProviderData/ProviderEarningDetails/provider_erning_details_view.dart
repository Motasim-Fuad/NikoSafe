import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Earning Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(earning.avatarUrl ?? ''),
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
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Get.textTheme.bodyMedium),
          Text(value, style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
