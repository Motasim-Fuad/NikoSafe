import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userData/drink_controller.dart';

class CreateDrinkTypeDialog extends StatefulWidget {
  const CreateDrinkTypeDialog({super.key});

  @override
  State<CreateDrinkTypeDialog> createState() => _CreateDrinkTypeDialogState();
}

class _CreateDrinkTypeDialogState extends State<CreateDrinkTypeDialog> {
  final DrinkController controller = Get.find<DrinkController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();
  final TextEditingController alcoholController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    volumeController.dispose();
    alcoholController.dispose();
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
                    'Create Custom Drink Type',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Add your own drink type to the list',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Drink Type Name
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'DRINK TYPE NAME',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Whiskey, Vodka, Rum',
                  hintStyle: TextStyle(color: Colors.white30),
                ),
              ),
              const SizedBox(height: 16),

              // Default Volume
              TextField(
                controller: volumeController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'DEFAULT VOLUME (ml)',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  suffixText: 'ml',
                  hintText: 'e.g., 44, 330, 150',
                  hintStyle: TextStyle(color: Colors.white30),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Default Alcohol Percentage
              TextField(
                controller: alcoholController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'DEFAULT ALCOHOL % (ABV)',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  suffixText: '%',
                  hintText: 'e.g., 40.0, 5.0, 12.0',
                  hintStyle: TextStyle(color: Colors.white30),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 24),

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
                        'This will be added to your drink types list for future logs',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Create Button
              Center(
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      if (nameController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter a drink type name',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      final volume = int.tryParse(volumeController.text);
                      final alcohol = double.tryParse(alcoholController.text);

                      if (volume == null || volume <= 0) {
                        Get.snackbar(
                          'Error',
                          'Please enter a valid default volume',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      if (alcohol == null || alcohol < 0 || alcohol > 100) {
                        Get.snackbar(
                          'Error',
                          'Please enter a valid alcohol percentage (0-100)',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      controller.createCustomDrinkType(
                        name: nameController.text,
                        defaultVolumeMl: volume,
                        defaultAlcoholPercentage: alcohol,
                      );

                      Get.back(); // Close this dialog
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
                        : const Text('Create Drink Type', style: TextStyle(color: Colors.black, fontSize: 16)),
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