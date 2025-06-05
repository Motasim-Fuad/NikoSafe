import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../View_Model/Controller/user/userData/drink_controller.dart';
import '../../../../models/UserData/drink_model.dart';

class AddDrinkDialog extends StatelessWidget {
  final DrinkController controller;
  final String day;
  final bool isEdit;
  final int? index;
  final Drink? drink;

  AddDrinkDialog({
    super.key,
    required this.controller,
    required this.day,
    this.isEdit = false,
    this.index,
    this.drink,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: isEdit ? drink?.name : '');
    TextEditingController volumeController = TextEditingController(text: isEdit ? drink?.volume.toString() : '');
    TextEditingController alcoholController = TextEditingController(text: isEdit ? drink?.alcoholPercentage.toString() : '');

    return Dialog(
      backgroundColor: const Color(0xFF2E3B4E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'DRINK NAME',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: volumeController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'VOLUME (ml)',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: alcoholController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'ALCOHOL % (ABV)',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (isEdit && index != null) {
                    controller.editDrink(
                      day,
                      index!,
                      nameController.text,
                      int.parse(volumeController.text),
                      double.parse(alcoholController.text),
                    );
                  } else {
                    controller.addDrink(
                      nameController.text,
                      int.parse(volumeController.text),
                      double.parse(alcoholController.text),
                      day,
                    );
                  }
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C4B4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(isEdit ? 'Update' : 'Save', style: const TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}