class Drink {
  final int? id;
  final int drinkType;
  final String drinkTypeName;
  final String drinkName;
  final int volumeMl;
  final double alcoholPercentage;
  final DateTime consumedAt;
  final String date;
  final double standardDrinks;
  final int calories;

  Drink({
    this.id,
    required this.drinkType,
    required this.drinkTypeName,
    required this.drinkName,
    required this.volumeMl,
    required this.alcoholPercentage,
    required this.consumedAt,
    required this.date,
    required this.standardDrinks,
    required this.calories,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      id: json['id'],
      drinkType: json['drink_type'],
      drinkTypeName: json['drink_type_name'] ?? '',
      drinkName: json['drink_name'] ?? '',
      volumeMl: json['volume_ml'],
      alcoholPercentage: double.parse(json['alcohol_percentage'].toString()),
      consumedAt: DateTime.parse(json['consumed_at']),
      date: json['date'],
      standardDrinks: double.parse(json['standard_drinks'].toString()),
      calories: json['calories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drink_type': drinkType,
      'drink_name': drinkName,
      'volume_ml': volumeMl.toString(),
      'alcohol_percentage': alcoholPercentage.toString(),
    };
  }
}

class DrinkType {
  final int id;
  final String name;
  final int defaultVolumeMl;
  final double defaultAlcoholPercentage;

  DrinkType({
    required this.id,
    required this.name,
    required this.defaultVolumeMl,
    required this.defaultAlcoholPercentage,
  });

  factory DrinkType.fromJson(Map<String, dynamic> json) {
    return DrinkType(
      id: json['id'],
      name: json['name'],
      defaultVolumeMl: json['default_volume_ml'],
      defaultAlcoholPercentage: double.parse(json['default_alcohol_percentage'].toString()),
    );
  }
}

class WeeklyDrinkPlan {
  final int? id;
  final int mondayLimit;
  final int mondayMaxMl;
  final int tuesdayLimit;
  final int tuesdayMaxMl;
  final int wednesdayLimit;
  final int wednesdayMaxMl;
  final int thursdayLimit;
  final int thursdayMaxMl;
  final int fridayLimit;
  final int fridayMaxMl;
  final int saturdayLimit;
  final int saturdayMaxMl;
  final int sundayLimit;
  final int sundayMaxMl;

  WeeklyDrinkPlan({
    this.id,
    required this.mondayLimit,
    required this.mondayMaxMl,
    required this.tuesdayLimit,
    required this.tuesdayMaxMl,
    required this.wednesdayLimit,
    required this.wednesdayMaxMl,
    required this.thursdayLimit,
    required this.thursdayMaxMl,
    required this.fridayLimit,
    required this.fridayMaxMl,
    required this.saturdayLimit,
    required this.saturdayMaxMl,
    required this.sundayLimit,
    required this.sundayMaxMl,
  });

  factory WeeklyDrinkPlan.fromJson(Map<String, dynamic> json) {
    return WeeklyDrinkPlan(
      id: json['id'],
      mondayLimit: json['monday_limit'],
      mondayMaxMl: json['monday_max_ml'],
      tuesdayLimit: json['tuesday_limit'],
      tuesdayMaxMl: json['tuesday_max_ml'],
      wednesdayLimit: json['wednesday_limit'],
      wednesdayMaxMl: json['wednesday_max_ml'],
      thursdayLimit: json['thursday_limit'],
      thursdayMaxMl: json['thursday_max_ml'],
      fridayLimit: json['friday_limit'],
      fridayMaxMl: json['friday_max_ml'],
      saturdayLimit: json['saturday_limit'],
      saturdayMaxMl: json['saturday_max_ml'],
      sundayLimit: json['sunday_limit'],
      sundayMaxMl: json['sunday_max_ml'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monday_limit': mondayLimit,
      'monday_max_ml': mondayMaxMl,
      'tuesday_limit': tuesdayLimit,
      'tuesday_max_ml': tuesdayMaxMl,
      'wednesday_limit': wednesdayLimit,
      'wednesday_max_ml': wednesdayMaxMl,
      'thursday_limit': thursdayLimit,
      'thursday_max_ml': thursdayMaxMl,
      'friday_limit': fridayLimit,
      'friday_max_ml': fridayMaxMl,
      'saturday_limit': saturdayLimit,
      'saturday_max_ml': saturdayMaxMl,
      'sunday_limit': sundayLimit,
      'sunday_max_ml': sundayMaxMl,
    };
  }

  int getLimitForDay(String day) {
    switch (day) {
      case 'Monday': return mondayLimit;
      case 'Tuesday': return tuesdayLimit;
      case 'Wednesday': return wednesdayLimit;
      case 'Thursday': return thursdayLimit;
      case 'Friday': return fridayLimit;
      case 'Saturday': return saturdayLimit;
      case 'Sunday': return sundayLimit;
      default: return 0;
    }
  }

  int getMaxMlForDay(String day) {
    switch (day) {
      case 'Monday': return mondayMaxMl;
      case 'Tuesday': return tuesdayMaxMl;
      case 'Wednesday': return wednesdayMaxMl;
      case 'Thursday': return thursdayMaxMl;
      case 'Friday': return fridayMaxMl;
      case 'Saturday': return saturdayMaxMl;
      case 'Sunday': return sundayMaxMl;
      default: return 0;
    }
  }
}

class BACCalculation {
  final int? id;
  final double bac;
  final double bacPercentage;
  final String warning;
  final String riskLevel;
  final DateTime calculatedAt;

  BACCalculation({
    this.id,
    required this.bac,
    required this.bacPercentage,
    required this.warning,
    required this.riskLevel,
    required this.calculatedAt,
  });

  factory BACCalculation.fromJson(Map<String, dynamic> json) {
    return BACCalculation(
      id: json['calculation_id'],
      bac: double.parse(json['bac'].toString()),
      bacPercentage: double.parse(json['bac_percentage'].toString()),
      warning: json['warning'] ?? '',
      riskLevel: json['risk_level'] ?? 'none',
      calculatedAt: DateTime.parse(json['calculated_at']),
    );
  }
}

class WeeklyStats {
  final Map<String, DayStats> stats;

  WeeklyStats({required this.stats});

  factory WeeklyStats.fromJson(Map<String, dynamic> json) {
    Map<String, DayStats> stats = {};
    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].forEach((day) {
      if (json[day] != null) {
        stats[day] = DayStats.fromJson(json[day]);
      }
    });
    return WeeklyStats(stats: stats);
  }
}

class DayStats {
  final int drinks;
  final int ml;

  DayStats({required this.drinks, required this.ml});

  factory DayStats.fromJson(Map<String, dynamic> json) {
    return DayStats(
      drinks: json['drinks'] ?? 0,
      ml: json['ml'] ?? 0,
    );
  }
}

class DailyStatus {
  final String date;
  final String day;
  final Map<String, int> limits;
  final Map<String, int> consumed;
  final Map<String, int> remaining;
  final bool exceeded;
  final String? status;

  DailyStatus({
    required this.date,
    required this.day,
    required this.limits,
    required this.consumed,
    required this.remaining,
    required this.exceeded,
    this.status,
  });

  factory DailyStatus.fromJson(Map<String, dynamic> json) {
    return DailyStatus(
      date: json['date'],
      day: json['day'],
      limits: Map<String, int>.from(json['limits']),
      consumed: Map<String, int>.from(json['consumed']),
      remaining: Map<String, int>.from(json['remaining']),
      exceeded: json['exceeded'],
      status: json['status'],
    );
  }
}