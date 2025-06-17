import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/providerTaskController/provider_task_controlller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/Authentication/widgets/common_widget.dart';
import 'package:nikosafe/view/provider/ProviderTaskManagement/service_detail_view.dart';

import '../../../models/Provider/providerTaskModel/provider_task_model.dart';


class ProviderTaskManagementView extends StatelessWidget {
  final ProviderTaskControlller controller = Get.put(ProviderTaskControlller());
final TextEditingController taskSearch=TextEditingController();
  ProviderTaskManagementView({super.key});



  @override
  Widget build(BuildContext context) {
    taskSearch.addListener(() {
      controller.filterTasksByDate(taskSearch.text);
    });
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title:  Text("Task Management",style: TextStyle(color: AppColor.primaryTextColor),),
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
              SizedBox(
                height: 20,
              ),

              //shorting with status
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: controller.selectedStatus.value,
                  dropdownColor: AppColor.topLinear,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    labelText: 'Filter by Status',
                    labelStyle: TextStyle(color: Colors.white),
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
              SizedBox(
                height: 20,
              ),

              Obx(() => Table(
                border: TableBorder.all(color: Colors.white24),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFF304E37)),
                    children: const [
                      Padding(padding: EdgeInsets.all(8), child: Text("Customer", style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text("Task", style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text("Date", style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text("Time", style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text("Status", style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text("Amount", style: TextStyle(color: Colors.white))),
                      Padding(padding: EdgeInsets.all(8), child: Text("delete", style: TextStyle(color: Colors.white))),
                    ],
                  ),
                  ...controller.filteredList.map((task) {
                    return TableRow(children: [
                      taskCell(task.customerName, task),
                      taskCell(task.task, task),
                      taskCell(task.date, task),
                      taskCell(task.time, task),
                      taskCell(task.status, task, color: task.status == "Completed" ? Colors.green : Colors.amber),
                      taskCell(task.amount, task),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            controller.deleteTask(task);
                          },
                        ),
                      ),

                    ]);
                  }).toList(),

                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget taskCell(String text, ProviderTaskModel task, {Color color = Colors.white}) {
    return InkWell(
      onTap: () {
        Get.to(() => ServiceDetailView(task: task));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: TextStyle(color: color)),
      ),
    );
  }

}
