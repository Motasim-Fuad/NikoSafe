class Drink {
  String name;
  int volume;
  double alcoholPercentage;
  DateTime timeConsumed;

  Drink({
    required this.name,
    required this.volume,
    required this.alcoholPercentage,
    required this.timeConsumed,
  });
}

class WeeklyDrinkPlan {
  int maxDrinks;
  int maxVolume;

  WeeklyDrinkPlan({
    required this.maxDrinks,
    required this.maxVolume,
  });
}