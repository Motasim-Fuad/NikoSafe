import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import '../../../../View_Model/Controller/user/userHome/connectController.dart';

class ConnectTabView extends StatelessWidget {
  final ConnectController controller = Get.put(ConnectController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: Text("User", style: TextStyle(
                  color: controller.selectedType.value == 'User' ? Colors.white : Colors.grey,
                )),
                selected: controller.selectedType.value == 'User',
                onSelected: (_) => controller.selectedType.value = 'User',
                selectedColor: Colors.cyan,
                backgroundColor: const Color(0xFF37474F),
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: Text("Service Provider", style: TextStyle(
                  color: controller.selectedType.value == 'Service Provider' ? Colors.white : Colors.grey,
                )),
                selected: controller.selectedType.value == 'Service Provider',
                onSelected: (_) => controller.selectedType.value = 'Service Provider',
                selectedColor: Colors.cyan,
                backgroundColor: const Color(0xFF37474F),
              ),
            ],
          ),
        )),
        Expanded(
          child: Obx(() => GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.filteredConnections.length,
            itemBuilder: (context, index) {
              final connection = controller.filteredConnections[index];
              return GestureDetector(
                onTap: () => controller.goToProfile(connection),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF23343F),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => controller.goToProfile(connection),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(connection.imageUrl),
                          radius: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => controller.goToProfile(connection),
                        child: Text(connection.name, style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => controller.sendFriendRequest(connection.name),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child:  Text("Connect",style: TextStyle(color: AppColor.blackTextColor),),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
        ),
      ],
    );
  }
}
