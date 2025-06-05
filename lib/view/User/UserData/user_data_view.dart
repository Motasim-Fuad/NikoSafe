import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/User/UserData/widgets/add_drink_dialog.dart';
import 'package:nikosafe/view/User/UserData/widgets/weekly_drink_plan_dialog.dart';
import '../../../View_Model/Controller/user/userData/drink_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/UserData/drink_model.dart';

class UserDataView extends StatelessWidget {
  final DrinkController controller = Get.put(DrinkController());

  UserDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: GetBuilder<DrinkController>(
        builder: (controller) {
          // Hardcoded user data for BAC calculation
          const double bodyWeight = 70; // kg
          const String gender = 'Male';

          // Calculate BAC for each day for the chart
          List<ChartData> chartData = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
              .map((day) => ChartData(
            day.substring(0, 3),
            controller.calculateBACForDay(day, bodyWeight: bodyWeight, gender: gender),
          ))
              .toList();

          return Scaffold(
            backgroundColor:Colors.transparent,
            appBar: AppBar(
              backgroundColor:Colors.transparent,
              title: const Text('My Data', style: TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Get.dialog(WeeklyDrinkPlanDialog());
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Weekly Drink Plan Summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Weekly Drink Plan',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E3B4E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${controller.totalDrinks} Drinks\n${controller.totalVolume}ml',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.center,
                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                          .map((day) {
                        String fullDay = {
                          'Mon': 'Monday',
                          'Tue': 'Tuesday',
                          'Wed': 'Wednesday',
                          'Thu': 'Thursday',
                          'Fri': 'Friday',
                          'Sat': 'Saturday',
                          'Sun': 'Sunday',
                        }[day]!;
                        bool isSelected = controller.selectedDay == fullDay;
                        return ElevatedButton(
                          onPressed: () {
                            controller.selectedDay = fullDay;
                            controller.update();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? const Color(0xFF00C4B4) : const Color(0xFF2E3B4E),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: Text(
                            day,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                        );
                      })
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    // Drink Pattern Chart
                    const Text(
                      'Your Drink Pattern',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E3B4E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries<ChartData, String>>[
                          ColumnSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            color: const Color(0xFFFFD700), // Yellow for Caution
                            pointColorMapper: (ChartData data, _) {
                              if (data.y > 0.08) return Colors.red;
                              if (data.y > 0.04) return Colors.yellow;
                              return Colors.blue;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text('Safe Zone 0.00%-0.03%', style: TextStyle(color: Colors.blue)),
                        Text('Caution 0.04%-0.07%', style: TextStyle(color: Colors.yellow)),
                        Text('Danger >0.08%', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Track Today Drinks
                    const Text(
                      'Track Today Drinks',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    ...?controller.drinksByDay[controller.selectedDay]?.asMap().entries.map((entry) {
                      int index = entry.key;
                      Drink drink = entry.value;
                      return ListTile(
                        title: Text(
                          '${drink.name} ${drink.volume}ml',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            Get.dialog(AddDrinkDialog(
                              controller: controller,
                              day: controller.selectedDay,
                              isEdit: true,
                              index: index,
                              drink: drink,
                            ));
                          },
                        ),
                      );
                    }),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.white),
                        onPressed: () {
                          Get.dialog(AddDrinkDialog(
                            controller: controller,
                            day: controller.selectedDay,
                          ));
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // BAC Calculator
                    const Text(
                      'Blood Alcohol Concentration (BAC) Calculator',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Gender', style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 10),
                        const Text('Male', style: TextStyle(color: Colors.white70)),
                        Radio(value: 'Male', groupValue: 'Male', onChanged: null),
                        const Text('Female', style: TextStyle(color: Colors.white70)),
                        Radio(value: 'Female', groupValue: 'Male', onChanged: null),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Body Weight',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('Kilograms', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Time Since First Drink',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('hours', style: TextStyle(color: Colors.white70)),
                        const SizedBox(width: 10),
                        const Text('30 minutes', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Amount of Alcohol Consumed',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C4B4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Calculate', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Calorie Calculator
                    const Text(
                      'Calorie Calculator',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Select the statement that best describes your usual activity level.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        RadioListTile(
                          title: Text('Inactive: Never or rarely include physical activity in your day.'),
                          value: 1,
                          groupValue: 1,
                          onChanged: null,
                        ),
                        RadioListTile(
                          title: Text('Somewhat active: Include light activity or moderate activity about two to three times a week.'),
                          value: 2,
                          groupValue: 1,
                          onChanged: null,
                        ),
                        RadioListTile(
                          title: Text('Active: Include at least 30 minutes of moderate activity most days of the week, or 20 minutes of vigorous activity at least three days a week.'),
                          value: 3,
                          groupValue: 1,
                          onChanged: null,
                        ),
                        RadioListTile(
                          title: Text('Very active: Include large amounts of moderate or vigorous activity in your day.'),
                          value: 4,
                          groupValue: 1,
                          onChanged: null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Food Energy Converter
                    const Text(
                      'Food Energy Converter',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: '2',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('Calorie', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C4B4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Calculate', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}