import '../../../models/Provider/providerHomeModel/earning_model.dart';

class EarningRepository {
  final Map<String, double> monthlyEarnings = {
    "JAN": 8322,
    "FEB": 9200,
    "MAR": 8600,
    "APR": 9100,
    "MAY": 9700,
    "JUN": 9900,
    "JUL": 10200,
    "AUG": 10800,
    "SEP": 10400,
    "OCT": 11200,
    "NOV": 11800,
    "DEC": 12500,
  };

  Future<EarningModel> fetchEarnings(String month) async {
    final months = monthlyEarnings.keys.toList();
    final index = months.indexOf(month);

    final currentMonthEarning = monthlyEarnings[month] ?? 0.0;
    final previousMonthEarning = index > 0 ? monthlyEarnings[months[index - 1]] ?? 0.0 : 0.0;

    return EarningModel(
      currentMonth: currentMonthEarning,
      previousMonth: previousMonthEarning,
    );
  }
}
