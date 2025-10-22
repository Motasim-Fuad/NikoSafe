import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userData/drink_controller.dart';

class BACCalculatorDialog extends StatefulWidget {
  const BACCalculatorDialog({super.key});

  @override
  State<BACCalculatorDialog> createState() => _BACCalculatorDialogState();
}

class _BACCalculatorDialogState extends State<BACCalculatorDialog> {
  final DrinkController controller = Get.find<DrinkController>();

  final TextEditingController totalAlcoholController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Auto-calculate total alcohol from today's drinks
    _calculateTotalAlcohol();
  }

  void _calculateTotalAlcohol() {
    if (controller.todayDrinks.isNotEmpty) {
      double totalAlcohol = controller.todayDrinks.fold(0.0, (sum, drink) {
        return sum + (drink.volumeMl * (drink.alcoholPercentage / 100));
      });
      totalAlcoholController.text = totalAlcohol.toStringAsFixed(1);

      // Calculate hours since first drink
      final firstDrink = controller.todayDrinks.first;
      final duration = DateTime.now().difference(firstDrink.consumedAt);
      hoursController.text = duration.inHours.toString();
      minutesController.text = (duration.inMinutes % 60).toString();
    }
  }

  @override
  void dispose() {
    totalAlcoholController.dispose();
    hoursController.dispose();
    minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2E3B4E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'BAC Calculator',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Calculate your Blood Alcohol Concentration',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Total Alcohol Consumed
              const Text(
                'TOTAL ALCOHOL CONSUMED (ml)',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: totalAlcoholController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixText: 'ml',
                  hintText: 'Pure alcohol in ml',
                  hintStyle: TextStyle(color: Colors.white30),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),

              // Time Since First Drink
              const Text(
                'TIME SINCE FIRST DRINK',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: hoursController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Hours',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: minutesController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Minutes',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Info Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.5)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'BAC is calculated using your profile data (gender, weight, age)',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Calculate Button
              Center(
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      final totalAlcohol = double.tryParse(totalAlcoholController.text);
                      final hours = int.tryParse(hoursController.text);
                      final minutes = int.tryParse(minutesController.text);

                      if (totalAlcohol == null || totalAlcohol <= 0) {
                        Get.snackbar(
                          'Error',
                          'Please enter a valid amount of alcohol consumed',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      if (hours == null || hours < 0) {
                        Get.snackbar(
                          'Error',
                          'Please enter valid hours',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      if (minutes == null || minutes < 0 || minutes >= 60) {
                        Get.snackbar(
                          'Error',
                          'Please enter valid minutes (0-59)',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      final totalHours = hours + (minutes / 60.0);

                      controller.calculateBAC(
                        totalAlcoholConsumedMl: totalAlcohol,
                        timeSinceFirstDrinkHours: totalHours,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C4B4),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                        : const Text('Calculate BAC', style: TextStyle(color: Colors.black, fontSize: 16)),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}