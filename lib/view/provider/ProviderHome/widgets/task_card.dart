import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/Provider/providerHomeModel/task_model.dart';
import '../../../../resource/App_routes/routes_name.dart';
import '../../../../resource/Colors/app_colors.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to task details page with booking ID
        Get.toNamed(
          RouteName.providerTaskDetailView,
          arguments: task.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[700]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.customerName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        task.taskTitle ?? 'No Title',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: task.isPaid ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.isPaid ? 'Paid' : 'Unpaid',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Date & Time
            if (task.bookingDate != null || task.bookingTime != null)
              Row(
                children: [
                  if (task.bookingDate != null) ...[
                    Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                    SizedBox(width: 8),
                    Text(
                      task.bookingDate!,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                  if (task.bookingTime != null) ...[
                    SizedBox(width: 20),
                    Icon(Icons.access_time, color: Colors.white70, size: 16),
                    SizedBox(width: 8),
                    Text(
                      task.bookingTime!,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ],
              ),
            SizedBox(height: 8),

            // Location
            if (task.location != null)
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white70, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.location!,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 12),

            // Description
            if (task.taskDescription != null)
              Text(
                task.taskDescription!,
                style: TextStyle(color: Colors.white60, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            SizedBox(height: 12),

            // Amount Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${task.hourlyRate}/hr × ${task.estimatedHours}h',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  'Total: \$${task.totalAmount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}