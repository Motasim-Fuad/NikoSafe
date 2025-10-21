import 'package:nikosafe/resource/App_Url/app_url.dart';
import '../../../data/network/network_api_services.dart';
import '../../../models/Provider/providerHomeModel/task_model.dart';

class TaskRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<List<TaskModel>> fetchTasks() async {
    try {
      final response = await _apiServices.getApi(
        AppUrl.providerBookingsUrl,
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch bookings');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskModel> fetchBookingDetails(int bookingId) async {
    try {
      final response = await _apiServices.getApi(
        AppUrl.getBookingDetailsUrl(bookingId),
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return TaskModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch booking details');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> acceptBooking(int bookingId) async {
    try {
      final Map<String, dynamic> requestData = {
        "action": "accept"
      };

      final response = await _apiServices.postApi(
        requestData,
        AppUrl.acceptRejectBookingUrl(bookingId),
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response;
      } else {
        throw Exception(response['message'] ?? 'Failed to accept booking');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> rejectBooking(int bookingId) async {
    try {
      final Map<String, dynamic> requestData = {
        "action": "reject"
      };

      final response = await _apiServices.postApi(
        requestData,
        AppUrl.acceptRejectBookingUrl(bookingId),
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response;
      } else {
        throw Exception(response['message'] ?? 'Failed to reject booking');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendQuote({
    required int bookingId,
    required String message,
    required double hourlyRate,
    required double estimatedHours,
    required double totalPrice,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "booking_id": bookingId,
        "message": message,
        "hourly_rate": hourlyRate,
        "estimated_hours": estimatedHours,
        "total_price": totalPrice,
      };

      final response = await _apiServices.postApi(
        requestData,
        AppUrl.sendQuoteUrl,
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response;
      } else {
        throw Exception(response['message'] ?? 'Failed to send quote');
      }
    } catch (e) {
      rethrow;
    }
  }
}