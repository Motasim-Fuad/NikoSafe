import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/providerTaskController/provider_services_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:nikosafe/view/provider/ProviderTaskManagement/service_detail_view.dart';
import '../../../models/Provider/providerTaskModel/provider_task_model.dart';

class ProviderServicesView extends StatelessWidget {
  final ProviderServicesControlller controller = Get.put(ProviderServicesControlller());
  final TextEditingController taskSearch = TextEditingController();

  final ScrollController horizontalHeaderController = ScrollController();
  final ScrollController horizontalBodyController = ScrollController();

  ProviderServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter by search text
    taskSearch.addListener(() {
      controller.filterTasksByDate(taskSearch.text);
    });

    // Sync horizontal scroll between header and body
    horizontalBodyController.addListener(() {
      horizontalHeaderController.jumpTo(horizontalBodyController.offset);
    });

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Task Management", style: TextStyle(color: AppColor.primaryTextColor)),
          automaticallyImplyLeading: false,
          centerTitle: false,
          actions: [
            // ✅ Refresh button in AppBar
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => controller.refreshTasks(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                controller: taskSearch,
                prefixIcon: Icons.search,
                hintText: "Search by Date (e.g. 2025-10-21)",
              ),
              const SizedBox(height: 20),
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: controller.selectedStatus.value,
                  dropdownColor: AppColor.topLinear,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    labelText: 'Filter by Status',
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.white,
                  items: controller.statusList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                          value == 'awaiting_confirmation' ? 'Awaiting Confirmation' :
                          value == 'accepted' ? 'Accepted' : value,
                          style: const TextStyle(color: Colors.white)
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) controller.onStatusChange(value);
                  },
                );
              }),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No bookings found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  // ✅ Wrap with RefreshIndicator for pull-to-refresh
                  return RefreshIndicator(
                    onRefresh: controller.refreshTasks,
                    backgroundColor: AppColor.topLinear,
                    color: Colors.white,
                    child: Column(
                      children: [
                        // ✅ Header (fixed vertically, scroll horizontally)
                        Container(
                          color: const Color(0xFF304E37),
                          height: 40,
                          child: SingleChildScrollView(
                            controller: horizontalHeaderController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                tableHeaderCell("Customer", 120),
                                tableHeaderCell("Task", 120),
                                tableHeaderCell("Date", 100),
                                tableHeaderCell("Time", 100),
                                tableHeaderCell("Status", 120),
                                tableHeaderCell("Amount", 80),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // ✅ Body scrolls vertically and horizontally
                        Expanded(
                          child: SingleChildScrollView(
                            controller: horizontalBodyController,
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(), // Enable pull refresh
                            child: SizedBox(
                              width: 640,
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(), // Enable pull refresh
                                itemCount: controller.filteredList.length,
                                itemBuilder: (context, index) {
                                  final task = controller.filteredList[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.white24)),
                                    ),
                                    height: 50,
                                    child: Row(
                                      children: [
                                        tableBodyCell(task.customerName, task, width: 120),
                                        tableBodyCell(task.displayTask, task, width: 120),
                                        tableBodyCell(task.displayDate, task, width: 100),
                                        tableBodyCell(task.displayTime, task, width: 100),
                                        tableBodyCell(
                                          _formatStatus(task.status),
                                          task,
                                          width: 120,
                                          color: _getStatusColor(task.status),
                                        ),
                                        tableBodyCell('\$${task.totalAmount}', task, width: 80),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
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

  String _formatStatus(String status) {
    if (status == 'awaiting_confirmation') return 'Awaiting';
    if (status == 'accepted') return 'Accepted';
    if (status == 'completed') return 'Completed';
    if (status == 'cancelled') return 'Cancelled';
    if (status == 'rejected') return 'Rejected';
    return status;
  }

  Widget tableHeaderCell(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget tableBodyCell(String text, ProviderServicesModel task,
      {double width = 100, Color color = Colors.white}) {
    return InkWell(
      onTap: () {
        Get.to(() => ServiceDetailView(task: task));
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(color: color),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}