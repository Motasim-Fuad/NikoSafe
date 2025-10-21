import 'package:get/get.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../../Repositry/Provider/providerHomeRepo/task_repo.dart';
import '../../../../models/Provider/providerHomeModel/task_model.dart';

class TaskController extends GetxController {
  final TaskRepository _repo = TaskRepository();

  var tasks = <TaskModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var selectedTask = Rxn<TaskModel>();
  var isLoadingDetails = false.obs;
  var detailsErrorMessage = ''.obs;

  // New observables for actions
  var isAccepting = false.obs;
  var isRejecting = false.obs;
  var isSendingQuote = false.obs;
  var actionMessage = ''.obs;
  var totalPrice = 0.0.obs;

  void calculateTotalPrice(String hourlyRate, String estimatedHours) {
    final rate = double.tryParse(hourlyRate) ?? 0;
    final hours = double.tryParse(estimatedHours) ?? 0;
    totalPrice.value = rate * hours;
  }

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final allTasks = await _repo.fetchTasks();

      // শুধুমাত্র "pending" status এর tasks filter করা
      tasks.value = allTasks.where((task) {
        return task.status.toLowerCase() == 'pending';
      }).toList();

    } catch (e) {
      errorMessage.value = e.toString();
      print('Error loading tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refreshTasks() async {
    await loadTasks();
  }

  Future<void> fetchBookingDetails(int bookingId) async {
    try {
      isLoadingDetails.value = true;
      detailsErrorMessage.value = '';
      selectedTask.value = await _repo.fetchBookingDetails(bookingId);
    } catch (e) {
      detailsErrorMessage.value = e.toString();
      print('Error loading booking details: $e');
    } finally {
      isLoadingDetails.value = false;
    }
  }

  // Accept booking
  Future<void> acceptBooking(int bookingId) async {
    try {
      isAccepting.value = true;
      actionMessage.value = '';

      final response = await _repo.acceptBooking(bookingId);

      // Dialog close করা
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Success snackbar দেখানো
      Utils.successSnackBar("Success", response['message'] ?? "Booking accepted successfully");

      // Task list refresh করা
      await loadTasks();

      // Details page থেকে back করা
      Get.back();

    } catch (e) {
      // Dialog close করা যদি open থাকে
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      actionMessage.value = e.toString();
      Utils.errorSnackBar("Error", "Failed to accept booking");
      print('Error accepting booking: $e');
    } finally {
      isAccepting.value = false;
    }
  }

  // Reject booking
  Future<void> rejectBooking(int bookingId) async {
    try {
      isRejecting.value = true;
      actionMessage.value = '';

      final response = await _repo.rejectBooking(bookingId);

      // Dialog close করা
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Success snackbar দেখানো
      Utils.successSnackBar("Success", response['message'] ?? "Booking rejected successfully");

      // Task list refresh করা
      await loadTasks();

      // Details page থেকে back করা
      Get.back();

    } catch (e) {
      // Dialog close করা যদি open থাকে
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      actionMessage.value = e.toString();
      Utils.errorSnackBar("Error", "Failed to reject booking");
      print('Error rejecting booking: $e');
    } finally {
      isRejecting.value = false;
    }
  }

  // Send quote
  Future<void> sendQuote({
    required int bookingId,
    required String message,
    required double hourlyRate,
    required double estimatedHours,
    required double totalPrice,
  }) async {
    try {
      isSendingQuote.value = true;
      actionMessage.value = '';
      final response = await _repo.sendQuote(
        bookingId: bookingId,
        message: message,
        hourlyRate: hourlyRate,
        estimatedHours: estimatedHours,
        totalPrice: totalPrice,
      );
      actionMessage.value = response['message'] ?? 'Quote sent successfully';

      // Refresh the task details
      await fetchBookingDetails(bookingId);

    } catch (e) {
      actionMessage.value = e.toString();
      print('Error sending quote: $e');
      rethrow;
    } finally {
      isSendingQuote.value = false;
    }
  }
}