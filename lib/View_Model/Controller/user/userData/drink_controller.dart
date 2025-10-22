import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userData_repo/Drink_repo.dart';
import 'package:nikosafe/models/User/UserData/drink_model.dart';

class DrinkController extends GetxController {
  final DrinkRepository _repository = DrinkRepository();

  // Observable variables
  var isLoading = false.obs;
  var isInitialized = false.obs;
  var drinkTypes = <DrinkType>[].obs;
  var todayDrinks = <Drink>[].obs;
  var drinkHistory = <Drink>[].obs;
  var weeklyPlan = Rxn<WeeklyDrinkPlan>();
  var weeklyStats = Rxn<WeeklyStats>();
  var dailyStatus = Rxn<DailyStatus>();
  var bacCalculation = Rxn<BACCalculation>();

  String selectedDay = 'Monday';

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  // Initialize all data
  Future<void> initializeData() async {
    try {
      isLoading.value = true;

      // Fetch all data without waiting for errors
      await Future.wait([
        fetchDrinkTypes(),
        fetchWeeklyPlan(),
        fetchTodayDrinks(),
        fetchWeeklyStats(),
        fetchDailyStatus(),
      ], eagerError: false); // Don't stop if one fails

      isInitialized.value = true;
    } catch (e) {
      print('Error initializing data: $e');
      isInitialized.value = true; // Still mark as initialized
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch drink types
  Future<void> fetchDrinkTypes() async {
    try {
      final types = await _repository.getDrinkTypes();
      drinkTypes.value = types;
    } catch (e) {
      print('Error fetching drink types: $e');
      drinkTypes.value = [];
    }
  }

  // Create custom drink type
  Future<void> createCustomDrinkType({
    required String name,
    required int defaultVolumeMl,
    required double defaultAlcoholPercentage,
  }) async {
    try {
      isLoading.value = true;
      final newDrinkType = await _repository.createCustomDrinkType(
        name: name,
        defaultVolumeMl: defaultVolumeMl,
        defaultAlcoholPercentage: defaultAlcoholPercentage,
      );

      if (newDrinkType != null) {
        drinkTypes.add(newDrinkType);
        Get.snackbar(
          'Success',
          'Custom drink type created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create custom drink type: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Log a drink
  Future<void> logDrink({
    required int drinkType,
    required String drinkName,
    required int volumeMl,
    required double alcoholPercentage,
  }) async {
    try {
      isLoading.value = true;
      final drink = await _repository.logDrink(
        drinkType: drinkType,
        drinkName: drinkName,
        volumeMl: volumeMl,
        alcoholPercentage: alcoholPercentage,
      );

      if (drink != null) {
        todayDrinks.add(drink);
        await fetchDailyStatus();
        await fetchWeeklyStats();

        Get.back(); // Close dialog
        Get.snackbar(
          'Success',
          'Drink logged successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to log drink: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch today's drinks
  Future<void> fetchTodayDrinks() async {
    try {
      final drinks = await _repository.getTodayDrinks();
      todayDrinks.value = drinks;
    } catch (e) {
      print('Error fetching today\'s drinks: $e');
      todayDrinks.value = [];
    }
  }

  // Fetch drink history
  Future<void> fetchDrinkHistory() async {
    try {
      isLoading.value = true;
      final history = await _repository.getDrinkHistory();
      drinkHistory.value = history;
    } catch (e) {
      print('Error fetching drink history: $e');
      drinkHistory.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Delete drink
  Future<void> deleteDrink(int drinkId) async {
    try {
      isLoading.value = true;
      await _repository.deleteDrink(drinkId);
      todayDrinks.removeWhere((drink) => drink.id == drinkId);
      await fetchDailyStatus();
      await fetchWeeklyStats();

      Get.snackbar(
        'Success',
        'Drink deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete drink: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch weekly plan
  Future<void> fetchWeeklyPlan() async {
    try {
      final plan = await _repository.getOrCreateWeeklyPlan();
      weeklyPlan.value = plan;
    } catch (e) {
      print('Error fetching weekly plan: $e');
      weeklyPlan.value = null;
    }
  }

  // Update weekly plan
  Future<void> updateWeeklyPlan(Map<String, Map<String, int>> planData) async {
    try {
      isLoading.value = true;

      final updatedPlan = WeeklyDrinkPlan(
        id: weeklyPlan.value?.id,
        mondayLimit: planData['Monday']!['maxDrinks']!,
        mondayMaxMl: planData['Monday']!['maxVolume']!,
        tuesdayLimit: planData['Tuesday']!['maxDrinks']!,
        tuesdayMaxMl: planData['Tuesday']!['maxVolume']!,
        wednesdayLimit: planData['Wednesday']!['maxDrinks']!,
        wednesdayMaxMl: planData['Wednesday']!['maxVolume']!,
        thursdayLimit: planData['Thursday']!['maxDrinks']!,
        thursdayMaxMl: planData['Thursday']!['maxVolume']!,
        fridayLimit: planData['Friday']!['maxDrinks']!,
        fridayMaxMl: planData['Friday']!['maxVolume']!,
        saturdayLimit: planData['Saturday']!['maxDrinks']!,
        saturdayMaxMl: planData['Saturday']!['maxVolume']!,
        sundayLimit: planData['Sunday']!['maxDrinks']!,
        sundayMaxMl: planData['Sunday']!['maxVolume']!,
      );

      final result = await _repository.updateWeeklyPlan(updatedPlan);
      if (result != null) {
        weeklyPlan.value = result;
        Get.back(); // Close dialog

        Get.snackbar(
          'Success',
          'Weekly plan updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update weekly plan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate BAC
  Future<void> calculateBAC({
    required double totalAlcoholConsumedMl,
    required double timeSinceFirstDrinkHours,
  }) async {
    try {
      isLoading.value = true;
      final result = await _repository.calculateBAC(
        totalAlcoholConsumedMl: totalAlcoholConsumedMl,
        timeSinceFirstDrinkHours: timeSinceFirstDrinkHours,
      );

      if (result != null) {
        bacCalculation.value = result;

        // Show result dialog
        Get.dialog(
          AlertDialog(
            backgroundColor: const Color(0xFF2E3B4E),
            title: const Text('BAC Result', style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BAC: ${result.bacPercentage.toStringAsFixed(2)}%',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Risk Level: ${result.riskLevel.toUpperCase()}',
                  style: TextStyle(
                    color: _getBACColor(result.bacPercentage),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  result.warning,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK', style: TextStyle(color: Color(0xFF00C4B4))),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to calculate BAC: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch weekly stats
  Future<void> fetchWeeklyStats() async {
    try {
      final stats = await _repository.getWeeklyStats();
      weeklyStats.value = stats;
    } catch (e) {
      print('Error fetching weekly stats: $e');
      weeklyStats.value = null;
    }
  }

  // Fetch daily status
  Future<void> fetchDailyStatus() async {
    try {
      final status = await _repository.checkDailyStatus();
      dailyStatus.value = status;
    } catch (e) {
      print('Error fetching daily status: $e');
      dailyStatus.value = null;
    }
  }

  // Helper: Get BAC color based on percentage
  Color _getBACColor(double bacPercentage) {
    if (bacPercentage > 0.08) return Colors.red;
    if (bacPercentage > 0.04) return Colors.yellow;
    return Colors.blue;
  }

  // Helper: Calculate BAC for chart (using weekly stats)
  double calculateBACForDay(String day) {
    if (weeklyStats.value == null) return 0.0;

    final dayAbbr = day.substring(0, 3);
    final stats = weeklyStats.value!.stats[dayAbbr];

    if (stats == null || stats.ml == 0) return 0.0;

    // Simple estimation for visualization
    double alcoholMl = stats.ml * 0.05;
    double bacEstimate = alcoholMl / 1000;

    return bacEstimate.clamp(0.0, 0.15);
  }

  // Get total drinks and volume
  int get totalDrinks {
    if (weeklyStats.value == null) return 0;
    return weeklyStats.value!.stats.values
        .fold(0, (sum, stats) => sum + stats.drinks);
  }

  int get totalVolume {
    if (weeklyStats.value == null) return 0;
    return weeklyStats.value!.stats.values
        .fold(0, (sum, stats) => sum + stats.ml);
  }
}