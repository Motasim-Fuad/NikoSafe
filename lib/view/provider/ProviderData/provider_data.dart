import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/view/provider/ProviderData/widgets/earningDataListTitle.dart';
import '../../../View_Model/Controller/provider/providerEarningDataController/providerEarningDataController.dart';


class ProviderEarningDataView extends StatelessWidget {
  final ProviderEarningDataController controller = Get.put(ProviderEarningDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: Column(
        children: [

          Text("hvsdhbvjhcbjhsdbcvjhbjhdsbcjhbjhcvbjhsdgujhbdfbuhbjhbuihgjhvcbujvhiuhfbjhbv dfsvhkjdfbdfjhfvgb"),

          Stack(
            children: [

            ],
          ),
          _buildBalanceCard(),
          const SizedBox(height: 16),
          _buildEarningsTable(),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(

      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.teal.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Balance', style: Get.textTheme.bodyLarge?.copyWith(color: Colors.white)),
          Obx(() => Text(
            controller.currentBalance.value,
            style: Get.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          )),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: controller.withdraw,
            child: const Text('Withdraw'),
          )
        ],
      ),
    );
  }

  Widget _buildEarningsTable() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.earnings.isEmpty) {
          return const Center(child: Text('No earnings to display.'));
        }
        return ListView.builder(
          itemCount: controller.earnings.length,
          itemBuilder: (_, index) => EarningListTile(
            earning: controller.earnings[index],
            onTap: () => controller.showEarningDetails(controller.earnings[index]),
          ),
        );
      }),
    );
  }
}
