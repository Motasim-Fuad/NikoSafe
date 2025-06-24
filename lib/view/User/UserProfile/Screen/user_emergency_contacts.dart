import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomNumericButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import '../../../../View_Model/Controller/userEmargencyContuctContrller/emergency_contact_controller.dart';

class UserEmergencyContactsView extends StatelessWidget {
  final EmergencyContactController controller = Get.put(EmergencyContactController(), permanent: true);


  UserEmergencyContactsView({super.key});

  void _showEditContactDialog(BuildContext context, int index, String currentName, String currentNumber) {
    String name = currentName;
    String number = currentNumber;

    final nameController = TextEditingController(text: currentName);
    final numberController = TextEditingController(text: currentNumber);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColor.topLinear,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: 300,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Contact",
                style: TextStyle(
                  color: AppColor.primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Enter name",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()
                ),
                onChanged: (val) => name = val,
              ),
              SizedBox(height: 15),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: numberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "Enter phone number",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()
                ),
                onChanged: (val) => number = val,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomNeumorphicButton(
                        backgroundColor: Colors.red,
                        Depth: 1,
                        labelDepth: 0,
                        label: "Cancel",
                        onPressed: () {
                          Navigator.pop(context);
                        }
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomNeumorphicButton(
                        backgroundColor: Colors.green,
                        Depth: 20,
                        labelDepth: 1,
                        label: "Update",
                        onPressed: () {
                          if (name.isNotEmpty && number.isNotEmpty) {
                            controller.editContact(index, name, number);
                            Navigator.pop(context);
                          }
                        }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    String name = "";
    String phoneNumber = "";

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColor.topLinear,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: 300,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Emergency Contact",
                style: TextStyle(
                  color: AppColor.primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Enter name",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()
                ),
                onChanged: (val) => name = val,
              ),
              SizedBox(height: 15),
              TextField(
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "Enter phone number",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()
                ),
                onChanged: (val) => phoneNumber = val,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomNeumorphicButton(
                        backgroundColor: Colors.red,
                        Depth: 1,
                        labelDepth: 0,
                        label: "Cancel",
                        onPressed: () {
                          Navigator.pop(context);
                        }
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomNeumorphicButton(
                        backgroundColor: Colors.green,
                        Depth: 20,
                        labelDepth: 1,
                        label: "Save",
                        onPressed: () {
                          if (name.isNotEmpty && phoneNumber.isNotEmpty) {
                            controller.addContact(name, phoneNumber);
                            Navigator.pop(context);
                          }
                        }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                      ?  Center(child: Text("No emergency contacts added yet.",style: TextStyle(color: AppColor.primaryTextColor),))
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
