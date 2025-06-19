import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/providerTaskController/provider_task_controlller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:nikosafe/view/provider/ProviderTaskManagement/service_detail_view.dart';
import '../../../models/Provider/providerTaskModel/provider_task_model.dart';

class ProviderTaskManagementView extends StatelessWidget {
  final ProviderTaskControlller controller = Get.put(ProviderTaskControlller());
  final TextEditingController taskSearch = TextEditingController();

  final ScrollController horizontalHeaderController = ScrollController();
  final ScrollController horizontalBodyController = ScrollController();

  ProviderTaskManagementView({super.key});

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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                controller: taskSearch,
                prefixIcon: Icons.search,
                hintText: "Search by Date (e.g. 25 January 2025)",
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
                      child: Text(value, style: const TextStyle(color: Colors.white)),
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
                  return Column(
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
                              tableHeaderCell("Status", 100),
                              tableHeaderCell("Amount", 80),
                              tableHeaderCell("Delete", 80),
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
                          child: SizedBox(
                            width: 700,
                            child: ListView.builder(
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
                                      tableBodyCell(task.task, task, width: 120),
                                      tableBodyCell(task.date, task, width: 100),
                                      tableBodyCell(task.time, task, width: 100),
                                      tableBodyCell(
                                        task.status,
                                        task,
                                        width: 100,
                                        color: task.status == "Completed"
                                            ? Colors.green
                                            : task.status == "Cancelled" ? Colors.red :Colors.amber,
                                      ),
                                      tableBodyCell(task.amount, task, width: 80),
                                      Container(
                                        width: 80,
                                        alignment: Alignment.center,
                                        child: IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            controller.deleteTask(task);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget tableBodyCell(String text, ProviderTaskModel task,
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
