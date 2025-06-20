import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../models/Provider/providerTaskModel/provider_task_model.dart';

class ServiceDetailView extends StatelessWidget {
  final ProviderTaskModel task;

  const ServiceDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Service Details",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: task.status == "Completed" ? Colors.green : task.status == "Cancelled" ?Colors.red :Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(task.status, style:  TextStyle(color: AppColor.primaryTextColor)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/1.jpg"),
                ),
                const SizedBox(width: 16),
                Expanded( // <-- Added Expanded here to fix overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Client: ${task.customerName}", style: const TextStyle(color: Colors.white)),
                      const Text("Email: abc@example.com", style: TextStyle(color: Colors.white)),
                      const Text("Phone: (319) 555-0115", style: TextStyle(color: Colors.white)),
                      const Text("Location: Downtown Los Angeles, CA", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Transaction details:", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 12),
            detailRow("Task ", task.task),
            detailRow("Price ", task.amount),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child:task.status == "Completed" ? SizedBox():task.status == "Cancelled" ? SizedBox():RoundButton(
                width: double.infinity,
                title: "Make as Complete",
                onPress: () {
                  Utils.successSnackBar("Task", "Task Complete Successful");
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
