import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import '../../../View_Model/Controller/provider/providerHomeController/task_controller.dart';

class ProviderTaskDetailsView extends StatelessWidget {
  const ProviderTaskDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final bookingId = Get.arguments as int?;

    if (bookingId == null) {
      return Scaffold(
        body: Center(
          child: Text("No booking ID provided"),
        ),
      );
    }

    // Fetch booking details
    taskController.fetchBookingDetails(bookingId);

    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Task Details",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: CustomBackButton(),
        ),
        body: Obx(() {
          if (taskController.isLoadingDetails.value) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (taskController.detailsErrorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load task details',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => taskController.fetchBookingDetails(bookingId),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final task = taskController.selectedTask.value;

          if (task == null) {
            return Center(
              child: Text(
                "No task data available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: width * 0.12,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.grey[700], size: 40),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Client: ${task.customerName}",
                            style: TextStyle(
                              color: AppColor.primaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          if (task.location != null)
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.white70, size: 16),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    task.location!,
                                    style: TextStyle(color: AppColor.primaryTextColor),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Payment Status
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: task.isPaid ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        task.isPaid ? Icons.check_circle : Icons.pending,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        task.isPaid ? 'Payment Completed' : 'Payment Pending',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Task Title
                if (task.taskTitle != null) ...[
                  Text(
                    "Task Title",
                    style: TextStyle(
                      color: AppColor.primaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    task.taskTitle!,
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ),
                  const SizedBox(height: 16),
                ],

                /// Task Description
                if (task.taskDescription != null) ...[
                  Text(
                    "Task Description",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryTextColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.taskDescription!,
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                  const SizedBox(height: 16),
                ],

                /// Time Info
                Text(
                  "Booking Information",
                  style: TextStyle(
                    color: AppColor.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      "Estimated Hours: ",
                      style: TextStyle(
                        color: AppColor.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${task.estimatedHours}h",
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                if (task.bookingDate != null)
                  Row(
                    children: [
                      Text(
                        "Booking Date: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryTextColor,
                        ),
                      ),
                      Text(
                        task.bookingDate!,
                        style: TextStyle(color: AppColor.primaryTextColor),
                      ),
                    ],
                  ),
                const SizedBox(height: 5),

                if (task.bookingTime != null)
                  Row(
                    children: [
                      Text(
                        "Preferred Time: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryTextColor,
                        ),
                      ),
                      Text(
                        task.bookingTime!,
                        style: TextStyle(color: AppColor.primaryTextColor),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),

                /// Pricing Info
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hourly Rate:",
                            style: TextStyle(color: AppColor.primaryTextColor),
                          ),
                          Text(
                            "\$${task.hourlyRate}/hr",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.white24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount:",
                            style: TextStyle(
                              color: AppColor.primaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "\$${task.totalAmount}",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Project Images
                if (task.bookingImages != null && task.bookingImages!.isNotEmpty) ...[
                  Text(
                    "Photos of the project",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryTextColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: task.bookingImages!.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, index) {
                        final image = task.bookingImages![index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            image.image,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 150,
                                height: 150,
                                color: Colors.grey[800],
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white54,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Show confirmation dialog
                          Get.dialog(
                            AlertDialog(
                              title: Text("Accept Booking", style: TextStyle(color: Colors.black)),
                              content: Text("Are you sure you want to accept this booking?", style: TextStyle(color: Colors.black87)),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text("Cancel", style: TextStyle(color: Colors.blue)),
                                ),
                                Obx(() => ElevatedButton(
                                  onPressed: taskController.isAccepting.value
                                      ? null
                                      : () => taskController.acceptBooking(task.id),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: taskController.isAccepting.value
                                      ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                      : Text("Yes, Accept", style: TextStyle(color: Colors.white)),
                                )),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Obx(() => taskController.isAccepting.value
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                            : Text(
                          "Accept Offer",
                          style: TextStyle(color: Colors.white),
                        ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Show confirmation dialog
                          Get.dialog(
                            AlertDialog(
                              title: Text("Reject Booking", style: TextStyle(color: Colors.black)),
                              content: Text("Are you sure you want to reject this booking?", style: TextStyle(color: Colors.black87)),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text("Cancel", style: TextStyle(color: Colors.blue)),
                                ),
                                Obx(() => ElevatedButton(
                                  onPressed: taskController.isRejecting.value
                                      ? null
                                      : () => taskController.rejectBooking(task.id),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: taskController.isRejecting.value
                                      ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                      : Text("Yes, Reject", style: TextStyle(color: Colors.white)),
                                )),
                              ],
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Obx(() => taskController.isRejecting.value
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2),
                        )
                            : Text(
                          "Reject Offer",
                          style: TextStyle(color: Colors.red),
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RoundButton(
                  width: double.infinity,
                  title: "Send Quote",
                  onPress: () {
                    Get.toNamed(
                      RouteName.providerSendQuoteView,
                      arguments: task.id, // Pass booking ID to quote screen
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}