import 'package:get/get.dart';

import '../../../../Repositry/Provider/providerTaskRepo/provider_task_repo.dart';
import '../../../../models/Provider/providerTaskModel/provider_task_model.dart';


class ProviderTaskControlller extends GetxController {
  var taskList = <ProviderTaskModel>[].obs;
  var filteredList = <ProviderTaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() {
    final repo = ProviderTaskRepo();
    taskList.value = repo.fetchTasks();
    filteredList.value = taskList; // Initialize filtered list
  }

  void filterTasksByDate(String query) {
    if (query.isEmpty) {
      filteredList.value = taskList;
    } else {
      filteredList.value = taskList.where((task) {
        return task.date.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}

