import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import '../../../../View_Model/Controller/userEmargencyContuctContrller/emergency_contact_controller.dart';

class UserEmergencyContactsView extends StatelessWidget {
  final EmergencyContactController controller = Get.put(EmergencyContactController());

  UserEmergencyContactsView({super.key});

  void _showEditContactDialog(BuildContext context, int index, String currentName, String currentNumber) {
    String name = currentName;
    String number = currentNumber;

    final nameController = TextEditingController(text: currentName);
    final numberController = TextEditingController(text: currentNumber);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Enter name"),
              onChanged: (val) => name = val,
            ),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: "Enter phone number"),
              onChanged: (val) => number = val,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (name.isNotEmpty && number.isNotEmpty) {
                controller.editContact(index, name, number);
                Navigator.pop(context);
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    String name = "";
    String phoneNumber = "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Emergency Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "Enter name"),
              onChanged: (val) => name = val,
            ),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: "Enter phone number"),
              onChanged: (val) => phoneNumber = val,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (name.isNotEmpty && phoneNumber.isNotEmpty) {
                controller.addContact(name, phoneNumber);
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 600;

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const CustomBackButton(),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text("Emergency Contacts", style: TextStyle(color: AppColor.primaryTextColor)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  return controller.contactList.isEmpty
                      ? const Center(child: Text("No emergency contacts added yet."))
                      : ListView.builder(
                    itemCount: controller.contactList.length,
                    itemBuilder: (_, index) {
                      final contact = controller.contactList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.topLinear,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Switch(
                                        value: contact.isEnabled,
                                        onChanged: (val) => controller.toggleContact(index, val),
                                        activeColor: AppColor.primaryTextColor,
                                        activeTrackColor: AppColor.limeColor,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            contact.name,
                                            style: TextStyle(
                                              color: AppColor.primaryTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: isSmallScreen ? 14 : 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            contact.number,
                                            style: TextStyle(
                                              color: AppColor.primaryTextColor,
                                              fontSize: isSmallScreen ? 12 : 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showEditContactDialog(context, index, contact.name, contact.number),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => controller.deleteContact(index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              RoundButton(
                width: double.infinity,
                title: "Add Emergency Contact",
                onPress: () => _showAddContactDialog(context),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
