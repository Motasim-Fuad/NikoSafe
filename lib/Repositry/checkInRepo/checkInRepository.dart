// check_in/repository/location_repository.dart

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UserCheckInRepository {
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
