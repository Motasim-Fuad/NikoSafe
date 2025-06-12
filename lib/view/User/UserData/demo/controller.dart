import 'dart:ui';

import 'package:get/get.dart';
import 'repo.dart';
import 'model.dart';
import 'package:intl/intl.dart';

enum BacViewMode { day, week, month }

class BacChartController extends GetxController {
  final BacDataRepository _repository = BacDataRepository();
  var bacEntries = <BacEntryModel>[].obs;
  var selectedMode = BacViewMode.day.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void addEntry(double bacValue) async {
    BacEntryModel entry = BacEntryModel(
      bacValue: bacValue,
      timestamp: DateTime.now(),
    );
    await _repository.saveEntry(entry);
    await loadData();
  }

  Future<void> loadData() async {
    bacEntries.value = await _repository.getAllEntries();
  }

  List<Map<String, dynamic>> getChartData() {
    switch (selectedMode.value) {
      case BacViewMode.day:
        return _groupByHour();
      case BacViewMode.week:
        return _groupByWeekday();
      case BacViewMode.month:
        return _groupByMonthlyWeek();
    }
  }

  List<Map<String, dynamic>> _groupByHour() {
    final now = DateTime.now();
    Map<String, double> hourly = {
      for (int i = 0; i < 24; i++) '${i.toString().padLeft(2, '0')}:00': 0.0,
    };

    for (var e in bacEntries) {
      if (_isToday(e.timestamp)) {
        String hour = '${e.timestamp.hour.toString().padLeft(2, '0')}:00';
        hourly[hour] = (hourly[hour] ?? 0) + e.bacValue;
      }
    }

    return hourly.entries.map((e) {
      double value = e.value;
      Color barColor;
      if (value <= 0.03) {
        barColor = Color(0xff649e3f); // Green
      } else if (value <= 0.07) {
        barColor = Color(0xffece108); // Yellow
      } else {
        barColor = Color(0xfff33636); // Red
      }

      return {
        'x': e.key,
        'y': value,
        'color': barColor,
      };
    }).toList();
  }


  List<Map<String, dynamic>> _groupByWeekday() {
    Map<String, double> weekdayMap = {
      'Mon': 0.0,
      'Tue': 0.0,
      'Wed': 0.0,
      'Thu': 0.0,
      'Fri': 0.0,
      'Sat': 0.0,
      'Sun': 0.0,
    };

    for (var e in bacEntries) {
      final weekday = DateFormat('E').format(e.timestamp); // 'Mon', 'Tue', etc.
      weekdayMap[weekday] = (weekdayMap[weekday] ?? 0) + e.bacValue;
    }

    return weekdayMap.entries.map((e) {
      double value = e.value;
      Color barColor;
      if (value <= 0.03) {
        barColor = const Color(0xff649e3f); // Green
      } else if (value <= 0.07) {
        barColor = const Color(0xffece108); // Yellow
      } else {
        barColor = const Color(0xfff33636); // Red
      }

      return {
        'x': e.key,
        'y': value,
        'color': barColor,
      };
    }).toList();
  }


  List<Map<String, dynamic>> _groupByMonthlyWeek() {
    final now = DateTime.now();
    Map<String, double> weekMap = {
      '1-7': 0.0,
      '8-14': 0.0,
      '15-21': 0.0,
      '22-28': 0.0,
      '29-31': 0.0,
    };

    for (var e in bacEntries) {
      if (e.timestamp.month == now.month && e.timestamp.year == now.year) {
        int day = e.timestamp.day;
        String weekRange;
        if (day <= 7) {
          weekRange = '1-7';
        } else if (day <= 14) {
          weekRange = '8-14';
        } else if (day <= 21) {
          weekRange = '15-21';
        } else if (day <= 28) {
          weekRange = '22-28';
        } else {
          weekRange = '29-31';
        }

        weekMap[weekRange] = (weekMap[weekRange] ?? 0) + e.bacValue;
      }
    }

    return weekMap.entries.map((e) {
      double value = e.value;
      Color barColor;
      if (value <= 0.03) {
        barColor = const Color(0xff649e3f); // Green
      } else if (value <= 0.07) {
        barColor = const Color(0xffece108); // Yellow
      } else {
        barColor = const Color(0xfff33636); // Red
      }

      return {
        'x': e.key,
        'y': value,
        'color': barColor,
      };
    }).toList();
  }


  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day;
  }

  bool _isSameWeek(DateTime date1, DateTime date2) {
    final startOfWeek = date2.subtract(Duration(days: date2.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date1.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date1.isBefore(endOfWeek.add(const Duration(days: 1)));
  }
}
