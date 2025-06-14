import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import '../../../../View_Model/Controller/provider/providerHomeController/earning_controller.dart';

class EarningCard extends StatelessWidget {
  final controller = Get.put(EarningController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final percent = controller.earningChangePercent;
      final isPositive = percent >= 0;
      return Card(
        color: AppColor.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Earning", style: TextStyle(color: AppColor.primaryTextColor)),
                  Text(
                    "\$${controller.earning.value.currentMonth.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Row(
                    children: [
                      Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 14, color: isPositive ? Colors.green : Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        "${percent.toStringAsFixed(1)}% from last month",
                        style: TextStyle(color: isPositive ? Colors.green : Colors.red),
                      ),
                    ],
                  )
                ],
              ),
              const Spacer(),
              DropdownButton<String>(
                value: controller.selectedMonth.value,
                dropdownColor: AppColor.cardColor,
                style: TextStyle(color: AppColor.primaryTextColor),
                underline: const SizedBox(),
                items: controller.months.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => controller.changeMonth(value!),
              ),
              // DropdownButtonTheme(
              //   data: DropdownButtonThemeData(
              //     menuMaxHeight: 150, // Approx height to show 3 items (3 * ~48)
              //   ),
              //   child: DropdownButton<String>(
              //     value: controller.selectedMonth.value,
              //     dropdownColor: AppColor.cardColor,
              //     style: TextStyle(color: AppColor.primaryTextColor),
              //     underline: const SizedBox(),
              //     items: controller.months.map(
              //           (e) => DropdownMenuItem(
              //         value: e,
              //         child: Text(e),
              //       ),
              //     ).toList(),
              //     onChanged: (value) => controller.changeMonth(value!),
              //   ),
              // )








            ],
          ),
        ),
      );
    });
  }
}
