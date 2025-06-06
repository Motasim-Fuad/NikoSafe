import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import '../../../../View_Model/Controller/userEmargencyContuctContrller/emergency_contact_controller.dart';


class UserEmergencyContactsView extends StatelessWidget {
  final EmergencyContactController controller = Get.put(EmergencyContactController());

  UserEmergencyContactsView({super.key});

  void _showAddContactDialog(BuildContext context) {
    String phoneNumber = "";
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Emergency Contact"),
        content: TextField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(hintText: "Enter phone number"),
          onChanged: (val) => phoneNumber = val,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (phoneNumber.isNotEmpty) {
                controller.addContact(phoneNumber);
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text("Emergency Contacts", style: TextStyle(color: AppColor.primaryTextColor)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () => _showAddContactDialog(context),
                icon: Icon(Icons.add),
                label: Text("Add Emergency Contact"),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Obx(() => ListView.builder(
                  itemCount: controller.contactList.length,
                  itemBuilder: (_, index) {
                    final contact = controller.contactList[index];
                    return Card(
                      child: ListTile(
                        title: Text(contact.number),
                        trailing: Switch(
                          value: contact.isEnabled,
                          onChanged: (val) => controller.toggleContact(index, val),
                        ),
                      ),
                    );
                  },
                )),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: controller.sendSOSAlert,
                icon: Icon(Icons.warning, color: Colors.white),
                label: Text("Send SOS Alert"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
