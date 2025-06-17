import 'package:flutter/material.dart';
import 'package:nikosafe/models/Provider/providerTaskModel/provider_task_model.dart';


class TaskCard extends StatelessWidget {
  final ProviderTaskModel task;
  final VoidCallback onView;

  const TaskCard({super.key, required this.task, required this.onView});

  Color getStatusColor(String status) {
    if (status == "In Progress") return Colors.amber;
    if (status == "Completed") return Colors.green;
    return Colors.grey;
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
            tableCell(task.task),
            tableCell(task.date),
            tableCell(task.time),
            tableCell(
              task.status,
              textColor: getStatusColor(task.status),
            ),
            tableCell(task.amount),
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
