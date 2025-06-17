import 'package:get/get.dart';

import '../../../../Repositry/Provider/providerTaskRepo/provider_task_repo.dart';
import '../../../../models/Provider/providerTaskModel/provider_task_model.dart';

class ProviderTaskControlller extends GetxController {
  var taskList = <ProviderTaskModel>[].obs;
  var filteredList = <ProviderTaskModel>[].obs;

  var selectedStatus = 'All'.obs;

  final statusList = ['All', 'Pending', 'Completed', 'Cancelled'];

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() {
    final repo = ProviderTaskRepo();
    taskList.value = repo.fetchTasks();
    filterTasks(); // Initialize filtered list
  }

  void filterTasksByDate(String query) {
    final lowerQuery = query.toLowerCase();
    filteredList.value = taskList.where((task) {
      final matchDate = task.date.toLowerCase().contains(lowerQuery);
      final matchStatus = selectedStatus.value == 'All' || task.status == selectedStatus.value;
      return matchDate && matchStatus;
    }).toList();
  }

  void onStatusChange(String value) {
    selectedStatus.value = value;
    filterTasks();
  }

  void filterTasks() {
    filteredList.value = taskList.where((task) {
      return selectedStatus.value == 'All' || task.status == selectedStatus.value;
    }).toList();
  }

  void deleteTask(ProviderTaskModel task) {
    taskList.remove(task);
    filterTasks();
  }
}


