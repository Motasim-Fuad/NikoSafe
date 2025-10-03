import 'package:get/get.dart';
import 'package:nikosafe/models/User/UserData/drink_model.dart';


class DrinkController extends GetxController {
  // Map to store drinks by day
  Map<String, List<Drink>> drinksByDay = {
    'Monday': [
      Drink(name: 'Beer', volume: 500, alcoholPercentage: 5.0, timeConsumed: DateTime.now()),
      Drink(name: 'Wine', volume: 150, alcoholPercentage: 12.0, timeConsumed: DateTime.now()),
    ],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [
      Drink(name: 'Beer', volume: 500, alcoholPercentage: 5.0, timeConsumed: DateTime.now()),
    ],
    'Saturday': [],
    'Sunday': [],
  };

  Map<String, WeeklyDrinkPlan> weeklyPlan = {
    'Monday': WeeklyDrinkPlan(maxDrinks: 1, maxVolume: 500),
    'Tuesday': WeeklyDrinkPlan(maxDrinks: 1, maxVolume: 500),
    'Wednesday': WeeklyDrinkPlan(maxDrinks: 1, maxVolume: 500),
    'Thursday': WeeklyDrinkPlan(maxDrinks: 1, maxVolume: 500),
    'Friday': WeeklyDrinkPlan(maxDrinks: 1, maxVolume: 500),
    'Saturday': WeeklyDrinkPlan(maxDrinks: 1, maxVolume: 500),
    'Sunday': WeeklyDrinkPlan(maxDrinks: 1, maxVolume: 500),
  };

  String selectedDay = 'Monday'; // Default selected day

  // Add a drink to a specific day
  void addDrink(String name, int volume, double alcoholPercentage, String day, {DateTime? timeConsumed}) {
    drinksByDay[day]!.add(Drink(
      name: name,
      volume: volume,
      alcoholPercentage: alcoholPercentage,
      timeConsumed: timeConsumed ?? DateTime.now(),
    ));
    update();
  }

  // Edit a drink for a specific day
  void editDrink(String day, int index, String name, int volume, double alcoholPercentage) {
    drinksByDay[day]![index] = Drink(
      name: name,
      volume: volume,
      alcoholPercentage: alcoholPercentage,
      timeConsumed: drinksByDay[day]![index].timeConsumed,
    );
    update();
  }

  // Update weekly plan for a specific day
  void updateWeeklyPlan(String day, int maxDrinks, int maxVolume) {
    weeklyPlan[day] = WeeklyDrinkPlan(maxDrinks: maxDrinks, maxVolume: maxVolume);
    update();
  }

  // Calculate total drinks and volume for the selected day
  int get totalDrinks => drinksByDay.values.expand((drinks) => drinks).length;
  int get totalVolume => drinksByDay.values.expand((drinks) => drinks).fold(0, (sum, drink) => sum + drink.volume);

  // Calculate BAC for a specific day
  double calculateBACForDay(String day, {required double bodyWeight, required String gender}) {
    List<Drink> drinks = drinksByDay[day] ?? [];
    if (drinks.isEmpty) return 0.0;

    // Calculate hours since first drink
    int hours = drinks.isNotEmpty
        ? DateTime.now().difference(drinks.first.timeConsumed).inHours
        : 0;

    double totalAlcoholGrams = drinks.fold(0.0, (sum, drink) => sum + (drink.volume * (drink.alcoholPercentage / 100) * 0.79));
    double r = gender == 'Male' ? 0.68 : 0.55; // Distribution ratio
    double bac = (totalAlcoholGrams / (bodyWeight * r)) - (0.015 * hours);
    return bac > 0 ? bac : 0.0;
  }

  // Placeholder for calorie calculation
  double calculateCalories(List<Drink> drinks) {
    return drinks.fold(0.0, (sum, drink) => sum + (drink.volume * (drink.alcoholPercentage / 100) * 7));
  }
}