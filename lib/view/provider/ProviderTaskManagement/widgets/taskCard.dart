import 'package:flutter/material.dart';
import 'package:nikosafe/models/Provider/providerTaskModel/provider_task_model.dart';

class TaskCard extends StatelessWidget {
  final ProviderServicesModel task;
  final VoidCallback onView;

  const TaskCard({super.key, required this.task, required this.onView});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      case 'accepted':
        return Colors.blue;
      case 'awaiting_confirmation':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableRowInkWell(
      onTap: onView,
      child: Table(
        border: TableBorder.all(color: Colors.white24),
        children: [
          TableRow(children: [
            tableCell(task.customerName),
            tableCell(task.displayTask),
            tableCell(task.displayDate),
            tableCell(task.displayTime),
            tableCell(
              task.status,
              textColor: getStatusColor(task.status),
            ),
            tableCell('\$${task.totalAmount}'),
          ]),
        ],
      ),
    );
  }

  Widget tableCell(String text, {Color textColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
    );
  }
}