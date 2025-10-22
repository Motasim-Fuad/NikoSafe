
import 'package:nikosafe/models/User/UserData/drink_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

import '../../../data/Network/network_api_services.dart' show NetworkApiServices;

class DrinkRepository {
  final _apiService = NetworkApiServices();

  // Get all drink types
  Future<List<DrinkType>> getDrinkTypes() async {
    try {
      final response = await _apiService.getApi(
        '${AppUrl.base_url}/api/basicuser/drink-types/',
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        List<DrinkType> drinkTypes = (response['data'] as List)
            .map((json) => DrinkType.fromJson(json))
            .toList();
        return drinkTypes;
      }
      return []; // Return empty list if no data
    } catch (e) {
      print('Error fetching drink types: $e');
      return []; // Return empty list on error
    }
  }

  // Create custom drink type
  Future<DrinkType?> createCustomDrinkType({
    required String name,
    required int defaultVolumeMl,
    required double defaultAlcoholPercentage,
  }) async {
    try {
      final response = await _apiService.postApi(
        {
          'name': name,
          'default_volume_ml': defaultVolumeMl,
          'default_alcohol_percentage': defaultAlcoholPercentage,
        },
        '${AppUrl.base_url}/api/basicuser/drink-types/',
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return DrinkType.fromJson(response['data']);
      }
      throw Exception(response['message'] ?? 'Failed to create custom drink type');
    } catch (e) {
      throw Exception('Error creating custom drink type: $e');
    }
  }

  // Log a drink
  Future<Drink?> logDrink({
    required int drinkType,
    required String drinkName,
    required int volumeMl,
    required double alcoholPercentage,
  }) async {
    try {
      final response = await _apiService.postApi(
        {
          'drink_type': drinkType,
          'drink_name': drinkName,
          'volume_ml': volumeMl.toString(),
          'alcohol_percentage': alcoholPercentage.toString(),
        },
        '${AppUrl.base_url}/api/basicuser/drinks/log/',
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return Drink.fromJson(response['data']);
      }
      throw Exception(response['message'] ?? 'Failed to log drink');
    } catch (e) {
      throw Exception('Error logging drink: $e');
    }
  }

  // Get today's drinks
  Future<List<Drink>> getTodayDrinks() async {
    try {
      final response = await _apiService.getApi(
        '${AppUrl.base_url}/api/basicuser/drinks/today/',
        requireAuth: true,
      );

      if (response['success'] == true) {
        // Handle both cases: drinks as direct array or nested in data
        var drinksData = response['data']['drinks'] ?? response['data'] ?? [];

        if (drinksData is List) {
          List<Drink> drinks = drinksData
              .map((json) => Drink.fromJson(json))
              .toList();
          return drinks;
        }
        return [];
      }
      return []; // Return empty list instead of throwing error
    } catch (e) {
      print('Error fetching today\'s drinks: $e');
      return []; // Return empty list on error
    }
  }

  // Get drink history
  Future<List<Drink>> getDrinkHistory() async {
    try {
      final response = await _apiService.getApi(
        '${AppUrl.base_url}/api/basicuser/drinks/history/',
        requireAuth: true,
      );

      if (response['success'] == true) {
        var drinksData = response['data']['drinks'] ?? response['data'] ?? [];

        if (drinksData is List) {
          List<Drink> drinks = drinksData
              .map((json) => Drink.fromJson(json))
              .toList();
          return drinks;
        }
        return [];
      }
      return [];
    } catch (e) {
      print('Error fetching drink history: $e');
      return [];
    }
  }

  // Delete a drink log
  Future<void> deleteDrink(int drinkId) async {
    try {
      final response = await _apiService.deleteApi(
        '${AppUrl.base_url}/api/basicuser/drinks/$drinkId/delete/',
        requireAuth: true,
      );

      if (response['success'] != true && response['status_code'] != 204) {
        throw Exception(response['message'] ?? 'Failed to delete drink');
      }
    } catch (e) {
      throw Exception('Error deleting drink: $e');
    }
  }

  // Get/Create weekly drink plan
  Future<WeeklyDrinkPlan?> getOrCreateWeeklyPlan() async {
    try {
      final response = await _apiService.getApi(
        '${AppUrl.base_url}/api/basicuser/drink-plan/',
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return WeeklyDrinkPlan.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching weekly plan: $e');
      return null;
    }
  }

  // Update weekly drink plan
  Future<WeeklyDrinkPlan?> updateWeeklyPlan(WeeklyDrinkPlan plan) async {
    try {
      final response = await _apiService.putApi(
        plan.toJson(),
        '${AppUrl.base_url}/api/basicuser/drink-plan/',
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return WeeklyDrinkPlan.fromJson(response['data']);
      }
      throw Exception(response['message'] ?? 'Failed to update weekly plan');
    } catch (e) {
      throw Exception('Error updating weekly plan: $e');
    }
  }

  // Calculate BAC
  Future<BACCalculation?> calculateBAC({
    required double totalAlcoholConsumedMl,
    required double timeSinceFirstDrinkHours,
  }) async {
    try {
      final response = await _apiService.postApi(
        {
          'total_alcohol_consumed_ml': totalAlcoholConsumedMl,
          'time_since_first_drink_hours': timeSinceFirstDrinkHours,
        },
        '${AppUrl.base_url}/api/basicuser/bac/calculate/',
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return BACCalculation.fromJson(response['data']);
      }
      throw Exception(response['message'] ?? 'Failed to calculate BAC');
    } catch (e) {
      throw Exception('Error calculating BAC: $e');
    }
  }

  // Get weekly stats
  Future<WeeklyStats?> getWeeklyStats() async {
    try {
      final response = await _apiService.getApi(
        '${AppUrl.base_url}/api/basicuser/drinks/week-stats/',
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return WeeklyStats.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching weekly stats: $e');
      return null;
    }
  }

  // Check daily status
  Future<DailyStatus?> checkDailyStatus() async {
    try {
      final response = await _apiService.getApi(
        '${AppUrl.base_url}/api/basicuser/stats/daily-status/',
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        return DailyStatus.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching daily status: $e');
      return null;
    }
  }
}