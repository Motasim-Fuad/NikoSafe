import 'package:get/get.dart';
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

  void loadTasks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      tasks.value = await _repo.fetchTasks();
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error loading tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refreshTasks() {
    loadTasks();
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
      actionMessage.value = response['message'] ?? 'Booking accepted successfully';

      // Refresh the task list and details
      await fetchBookingDetails(bookingId);
      loadTasks();

      Get.back(); // Close any dialog if open
    } catch (e) {
      actionMessage.value = e.toString();
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
      actionMessage.value = response['message'] ?? 'Booking rejected successfully';

      // Refresh the task list and details
      await fetchBookingDetails(bookingId);
      loadTasks();

      Get.back(); // Close any dialog if open
    } catch (e) {
      actionMessage.value = e.toString();
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