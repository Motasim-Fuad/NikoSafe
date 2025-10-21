import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/Provider/providerHomeModel/task_model.dart';
import '../../../../resource/App_routes/routes_name.dart';
import '../../../../resource/Colors/app_colors.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  // Status এর জন্য color এবং text return করে
  Map<String, dynamic> getStatusInfo() {
    final status = task.status.toLowerCase();

    if (status == 'pending') {
      return {
        'color': Colors.orange,
        'text': 'Pending',
        'icon': Icons.pending
      };
    } else if (status == 'awaiting_confirmation') {
      return {
        'color': Colors.blue,
        'text': 'New Request',
        'icon': Icons.notifications_active
      };
    }

    return {
      'color': Colors.grey,
      'text': 'Unknown',
      'icon': Icons.help_outline
    };
  }

  @override
  Widget build(BuildContext context) {
    final statusInfo = getStatusInfo();

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
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusInfo['color'],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusInfo['icon'],
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        statusInfo['text'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Payment Status Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: task.isPaid ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: task.isPaid ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        task.isPaid ? Icons.check_circle : Icons.cancel,
                        color: task.isPaid ? Colors.green : Colors.red,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        task.isPaid ? 'Paid' : 'Unpaid',
                        style: TextStyle(
                          color: task.isPaid ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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

            if (task.bookingDate != null || task.bookingTime != null)
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

            if (task.location != null)
              SizedBox(height: 12),

            // Description
            if (task.taskDescription != null) ...[
              Text(
                task.taskDescription!,
                style: TextStyle(color: Colors.white60, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
            ],

            // Amount Info
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hourly Rate',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$${task.hourlyRate}/hr × ${task.estimatedHours}h',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$${task.totalAmount}',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}