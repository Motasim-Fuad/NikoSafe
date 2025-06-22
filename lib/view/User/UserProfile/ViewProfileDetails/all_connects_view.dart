import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../View_Model/Controller/user/MyProfile/my_profile_details_controller/connectController.dart';

class AllConnectsView extends StatelessWidget {
  final controller = Get.put(ConnectsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF253038),
      appBar: AppBar(
        title: Text('All Connects', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF253038),
        leading: BackButton(color: Colors.white),
      ),
      body: Obx(() => GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.connects.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, index) {
          final user = controller.connects[index];
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF37424A),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(user.imageUrl),
                ),
                SizedBox(height: 8),
                Text(user.name, style: TextStyle(color: Colors.white)),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.tealAccent),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => controller.removeConnect(index),
                      child: Text("Remove", style: TextStyle(color: Colors.red)),
                    )
                  ],
                )
              ],
            ),
          );
        },
      )),
    );
  }
}
