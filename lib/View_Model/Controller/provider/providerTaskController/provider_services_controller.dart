import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/Provider/provider_services_Repo/provider_services_repo.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../../models/Provider/providerTaskModel/provider_task_model.dart';

class ProviderServicesControlller extends GetxController {
  var taskList = <ProviderServicesModel>[].obs;
  var filteredList = <ProviderServicesModel>[].obs;
  var isLoading = false.obs;

  var selectedStatus = 'All'.obs;
  final statusList = ['All', 'awaiting_confirmation', 'accepted'];

  final _repo = ProviderServicesRepo();

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      isLoading.value = true;
      final bookings = await _repo.fetchBookings();
      taskList.value = bookings;
      filterTasks();
    } catch (e) {
      Utils.errorSnackBar('Error', 'Failed to load bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Refresh function
  Future<void> refreshTasks() async {
    await loadTasks();
  }

  void filterTasksByDate(String query) {
    final lowerQuery = query.toLowerCase();
    filteredList.value = taskList.where((task) {
      final matchDate = task.displayDate.toLowerCase().contains(lowerQuery);
      final matchStatus = _matchesSelectedStatus(task);
      return matchDate && matchStatus;
    }).toList();
  }

  bool _matchesSelectedStatus(ProviderServicesModel task) {
    if (selectedStatus.value == 'All') {
      return task.status == 'awaiting_confirmation' || task.status == 'accepted';
    }
    return task.status == selectedStatus.value;
  }

  void onStatusChange(String value) {
    selectedStatus.value = value;
    filterTasks();
  }

  void filterTasks() {
    filteredList.value = taskList.where((task) {
      return _matchesSelectedStatus(task);
    }).toList();
  }

  Future<void> completeBooking(ProviderServicesModel task) async {
    try {
      isLoading.value = true;
      final success = await _repo.completeBooking(task.id);

      if (success) {
        Utils.successSnackBar("Success", "Booking marked as complete");
        await loadTasks(); // Refresh after complete
        Get.back(); // Go back to list
      } else {
        Utils.errorSnackBar("Error", "Failed to complete booking");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to complete booking: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBooking(ProviderServicesModel task) async {
    if (task.status != 'accepted') {
      Utils.errorSnackBar("Error", "Only accepted bookings can be cancelled");
      return;
    }

    try {
      isLoading.value = true;
      final success = await _repo.cancelBooking(task.id);

      if (success) {
        Utils.successSnackBar("Success", "Booking cancelled successfully");
        await loadTasks(); // Refresh after cancel
        Get.back(); // Go back to list
      } else {
        Utils.errorSnackBar("Error", "Failed to cancel booking");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to cancel booking: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void deleteTask(ProviderServicesModel task) {
    taskList.remove(task);
    filterTasks();
  }
}