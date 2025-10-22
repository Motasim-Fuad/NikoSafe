import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userData/drink_controller.dart';

class WeeklyDrinkPlanDialog extends StatefulWidget {
  const WeeklyDrinkPlanDialog({super.key});

  @override
  State<WeeklyDrinkPlanDialog> createState() => _WeeklyDrinkPlanDialogState();
}

class _WeeklyDrinkPlanDialogState extends State<WeeklyDrinkPlanDialog> {
  final DrinkController controller = Get.find<DrinkController>();

  late Map<String, Map<String, TextEditingController>> controllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    controllers = {};
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    for (var day in days) {
      if (controller.weeklyPlan.value != null) {
        controllers[day] = {
          'maxDrinks': TextEditingController(
            text: controller.weeklyPlan.value!.getLimitForDay(day).toString(),
          ),
          'maxVolume': TextEditingController(
            text: controller.weeklyPlan.value!.getMaxMlForDay(day).toString(),
          ),
        };
      } else {
        controllers[day] = {
          'maxDrinks': TextEditingController(text: '2'),
          'maxVolume': TextEditingController(text: '500'),
        };
      }
    }
  }

  @override
  void dispose() {
    controllers.values.forEach((dayControllers) {
      dayControllers.values.forEach((controller) => controller.dispose());
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2E3B4E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Weekly Drink Plan',
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
                'Set your daily limits for drinks and volume',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Column Headers
              Row(
                children: const [
                  Expanded(
                    flex: 2,
                    child: Text('Day', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Max Drinks', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Max (ml)', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(color: Colors.white30),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                        .map((day) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                day.substring(0, 3),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: controllers[day]!['maxDrinks'],
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: controllers[day]!['maxVolume'],
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      Map<String, Map<String, int>> planData = {};

                      for (var day in controllers.keys) {
                        final maxDrinks = int.tryParse(controllers[day]!['maxDrinks']!.text);
                        final maxVolume = int.tryParse(controllers[day]!['maxVolume']!.text);

                        if (maxDrinks == null || maxDrinks < 0) {
                          Get.snackbar(
                            'Error',
                            'Please enter a valid number for $day max drinks',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        if (maxVolume == null || maxVolume < 0) {
                          Get.snackbar(
                            'Error',
                            'Please enter a valid number for $day max volume',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        planData[day] = {
                          'maxDrinks': maxDrinks,
                          'maxVolume': maxVolume,
                        };
                      }

                      controller.updateWeeklyPlan(planData);
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
                        : const Text('Save', style: TextStyle(color: Colors.black, fontSize: 16)),
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