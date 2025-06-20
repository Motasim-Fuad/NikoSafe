import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customSearchBar.dart';
import '../../../View_Model/Controller/user/userHome/connectController.dart';

class ConnectTabView extends StatefulWidget {
  const ConnectTabView({super.key});

  @override
  State<ConnectTabView> createState() => _ConnectTabViewState();
}

class _ConnectTabViewState extends State<ConnectTabView> {
  final ConnectController controller = Get.put(ConnectController());
  late TextEditingController searchFieldController;

  @override
  void initState() {
    super.initState();
    searchFieldController = TextEditingController();
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        CustomSearchBar(
          controller: searchFieldController,
          onChanged: (value) => controller.updateSearch(value),
        ),

        // User Grid
        Expanded(
          child: Obx(() => controller.filteredConnections.isEmpty
              ? const Center(child: Text('No users found', style: TextStyle(color: Colors.white)))
              : GridView.builder(
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
                    color: AppColor.iconColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(connection.imageUrl),
                        radius: 30,
                      ),
                      const SizedBox(height: 10),
                      Text(connection.name, style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => controller.sendFriendRequest(connection.name),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Connect",
                          style: TextStyle(color: AppColor.blackTextColor),
                        ),
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


