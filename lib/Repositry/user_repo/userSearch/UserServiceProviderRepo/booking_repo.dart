import 'dart:io';
import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class BookingRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> createBooking({
    required int providerId,
    required String totalAmount, // ✅ এইটা MUST পাঠাতে হবে
    String? bookingDate,
    String? bookingTime,
    String? hourlyRate, // ✅ Backend requires this
    String? estimatedHours, // ✅ Backend requires this
    String? taskTitle,
    String? taskDescription,
    String? location,
    List<File>? images,
  }) async {
    try {
      // ✅ Include all required fields
      final data = <String, dynamic>{
        "provider_id": providerId,
        "total_amount": totalAmount, // ✅ Backend এ required
      };

      // Optional fields
      if (bookingDate != null) data["booking_date"] = bookingDate;
      if (bookingTime != null) data["booking_time"] = bookingTime;
      if (hourlyRate != null) data["hourly_rate"] = hourlyRate; // ✅ Add this
      if (estimatedHours != null) data["estimated_hours"] = estimatedHours; // ✅ Add this
      if (taskTitle != null) data["task_title"] = taskTitle;
      if (taskDescription != null) data["task_description"] = taskDescription;
      if (location != null) data["location"] = location;

      print("📤 Creating booking with data: $data");

      // ✅ Always use form-data
      if (images != null && images.isNotEmpty) {
        return await _apiService.postMultipartApiWithMultipleImages(
          url: AppUrl.createBookingUrl,
          data: data,
          images: images,
          imageFieldName: "images",
          requireAuth: true,
        );
      } else {
        return await _apiService.postMultipartApi(
          url: AppUrl.createBookingUrl,
          data: data,
          imageFile: null,
          requireAuth: true,
        );
      }
    } catch (e) {
      print("❌ Booking error: $e");
      rethrow;
    }
  }
}