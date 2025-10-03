import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userData/drink_controller.dart';


class WeeklyDrinkPlanDialog extends StatelessWidget {
  final DrinkController controller = Get.find<DrinkController>();

  WeeklyDrinkPlanDialog({super.key});


  Widget build(BuildContext context) {
    // Create maps to store TextEditingControllers for each day
    Map<String, TextEditingController> maxDrinksControllers = {};
    Map<String, TextEditingController> maxVolumeControllers = {};

    // Initialize controllers for each day
    controller.weeklyPlan.keys.forEach((day) {
      maxDrinksControllers[day] = TextEditingController(
        text: controller.weeklyPlan[day]!.maxDrinks.toString(),
      );
      maxVolumeControllers[day] = TextEditingController(
        text: controller.weeklyPlan[day]!.maxVolume.toString(),
      );
    });

    return Dialog(
      backgroundColor: const Color(0xFF2E3B4E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // Adjust padding to avoid overflow
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500), // Limit the dialog height
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
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Daily Limits',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Expanded( // Use Expanded to allow scrolling within the available space
                child: SingleChildScrollView(
                  child: Column(
                    children: controller.weeklyPlan.keys.map((day) {
                      return Row(
                        children: [
                          Expanded(child: Text(day, style: const TextStyle(color: Colors.white))),
                          Expanded(
                            child: TextField(
                              controller: maxDrinksControllers[day],
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Max Drinks',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: maxVolumeControllers[day],
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Max (ml)',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Update the weekly plan with the values from the TextFields
                    controller.weeklyPlan.forEach((day, plan) {
                      // int maxDrinks = int.tryParse(maxDrinksControllers[day]!.text) ?? plan?.maxDrinks;
                      // int maxVolume = int.tryParse(maxVolumeControllers[day]!.text) ?? plan?.maxVolume;
                      // controller.updateWeeklyPlan(day, maxDrinks, maxVolume);
                    });
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C4B4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}