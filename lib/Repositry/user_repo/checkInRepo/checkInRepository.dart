// check_in/repository/location_repository.dart

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class UserCheckInRepository {


  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Map<String, dynamic>> createCheckInPost({
    required String title,
    required String text,
    required String locationName,
    required double latitude,
    required double longitude,
    required String address,
    required int privacy,
    required int postType,
  }) async {
    try {
      final data = {
        "title": title,
        "text": text,
        "location_name": locationName,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "privacy": privacy,
        "post_type": postType,
      };

      final response = await _apiServices.postApi(
        data,
        AppUrl.socialCreateCheckIn, // You'll need to add this URL to your AppUrl class
        requireAuth: true, // This requires authentication
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<Position> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied.");
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return "${place.name}, ${place.locality}, ${place.country}";
    } else {
      return "Unknown location";
    }
  }
}
