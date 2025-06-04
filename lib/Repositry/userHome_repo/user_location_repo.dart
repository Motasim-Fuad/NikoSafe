


import '../../models/userCreatePost/UserLocation/user_location_model.dart';

class UserLocationRepository {
  // Simulate fetching locations from an API or local database
  Future<List<UserLocationModel>> getRecentPlaces() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      UserLocationModel(id: '1', name: 'The Urban Fork', address: 'Berlin, Germany', latitude: 52.5200, longitude: 13.4050),
      UserLocationModel(id: '2', name: 'Brand New Cafe', address: 'Paris, France', latitude: 48.8566, longitude: 2.3522),
      UserLocationModel(id: '3', name: 'Central Park', address: 'New York, USA', latitude: 40.785091, longitude: -73.968285),
      UserLocationModel(id: '4', name: 'Eiffel Tower', address: 'Paris, France', latitude: 48.8584, longitude: 2.2945),
      UserLocationModel(id: '5', name: 'Colosseum', address: 'Rome, Italy', latitude: 41.8902, longitude: 12.4922),
      UserLocationModel(id: '6', name: 'Tokyo Skytree', address: 'Tokyo, Japan', latitude: 35.7100, longitude: 139.8107),
      UserLocationModel(id: '7', name: 'Sydney Opera House', address: 'Sydney, Australia', latitude: -33.8568, longitude: 151.2153),
      UserLocationModel(id: '8', name: 'Big Ben', address: 'London, UK', latitude: 51.5007, longitude: -0.1246),
    ];
  }

  // Simulate searching for locations
  Future<List<UserLocationModel>> searchLocations(String query) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    final allLocations = await getRecentPlaces();
    if (query.isEmpty) {
      return allLocations;
    }
    return allLocations
        .where((location) =>
    location.name.toLowerCase().contains(query.toLowerCase()) ||
        location.address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}