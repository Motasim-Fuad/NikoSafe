import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/providerTaskController/provider_services_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import '../../../models/Provider/providerTaskModel/provider_task_model.dart';

class ServiceDetailView extends StatelessWidget {
  final ProviderServicesModel task;

  const ServiceDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProviderServicesControlller>();

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
        body: Obx(() => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: task.status == "completed"
                      ? Colors.green
                      : task.status == "cancelled"
                      ? Colors.red
                      : task.status == "accepted"
                      ? Colors.blue
                      : Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.status.toUpperCase(),
                  style: TextStyle(color: AppColor.primaryTextColor),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/men/1.jpg"),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Client: ${task.customerName}",
                            style: const TextStyle(color: Colors.white)),
                        if (task.location != null)
                          Text("Location: ${task.location}",
                              style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Transaction details:",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 12),
              detailRow("Task", task.displayTask),
              detailRow("Date", task.displayDate),
              detailRow("Time", task.displayTime),
              detailRow("Hourly Rate", "\$${task.hourlyRate}"),
              detailRow("Estimated Hours", task.estimatedHours),
              detailRow("Total Amount", "\$${task.totalAmount}"),
              detailRow("Payment Status", task.isPaid ? "Paid" : "Unpaid"),
              const Spacer(),

              // ✅ Only show buttons for "accepted" status
              // ✅ No buttons for "awaiting_confirmation"
              if (task.status == "accepted")
                Row(
                  children: [
                    Expanded(
                      child: RoundButton(
                        title: "Mark as Complete",
                        onPress: () {
                          controller.completeBooking(task);
                        },
                        buttonColor: Colors.green,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RoundButton(
                        title: "Cancel",
                        onPress: () {
                          controller.cancelBooking(task);
                        },
                        buttonColor: Colors.red,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        )),
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}