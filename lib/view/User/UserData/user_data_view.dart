import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/User/UserData/widgets/add_drink_dialog.dart';
import 'package:nikosafe/view/User/UserData/widgets/weekly_drink_plan_dialog.dart';
import 'package:nikosafe/view/User/UserData/widgets/bac_calculator_dialog.dart';
import '../../../View_Model/Controller/user/userData/drink_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UserDataView extends StatelessWidget {
  final DrinkController controller = Get.put(DrinkController());

  UserDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value && controller.weeklyStats.value == null) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text('My Data', style: TextStyle(color: Colors.white)),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Calculate chart data
        List<ChartData> chartData = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
            .map((day) => ChartData(
          day.substring(0, 3),
          controller.calculateBACForDay(day),
        ))
            .toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('My Data', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Get.dialog(const WeeklyDrinkPlanDialog());
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.initializeData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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

                    // Day Selection Buttons
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.center,
                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
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
                      }).toList(),
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
                        primaryXAxis: CategoryAxis(
                          labelStyle: const TextStyle(color: Colors.white70),
                        ),
                        primaryYAxis: NumericAxis(
                          labelStyle: const TextStyle(color: Colors.white70),
                        ),
                        series: <CartesianSeries<ChartData, String>>[
                          ColumnSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
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

                    // Daily Status Card
                    if (controller.dailyStatus.value != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: controller.dailyStatus.value!.exceeded
                              ? Colors.red.withOpacity(0.2)
                              : const Color(0xFF2E3B4E),
                          borderRadius: BorderRadius.circular(10),
                          border: controller.dailyStatus.value!.exceeded
                              ? Border.all(color: Colors.red, width: 2)
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Today\'s Status - ${controller.dailyStatus.value!.day}',
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                if (controller.dailyStatus.value!.exceeded)
                                  const Icon(Icons.warning, color: Colors.red),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatusItem(
                                  'Limit',
                                  '${controller.dailyStatus.value!.limits['max_drinks']} drinks',
                                  '${controller.dailyStatus.value!.limits['max_ml']} ml',
                                ),
                                _buildStatusItem(
                                  'Consumed',
                                  '${controller.dailyStatus.value!.consumed['total_drinks']} drinks',
                                  '${controller.dailyStatus.value!.consumed['total_ml']} ml',
                                ),
                                _buildStatusItem(
                                  'Remaining',
                                  '${controller.dailyStatus.value!.remaining['drinks']} drinks',
                                  '${controller.dailyStatus.value!.remaining['ml']} ml',
                                ),
                              ],
                            ),
                            if (controller.dailyStatus.value!.status != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  controller.dailyStatus.value!.status!,
                                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Track Today Drinks
                    const Text(
                      'Track Today Drinks',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),

                    if (controller.todayDrinks.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'No drinks logged today',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      )
                    else
                      ...controller.todayDrinks.map((drink) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E3B4E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${drink.drinkTypeName} - ${drink.drinkName}',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${drink.volumeMl}ml • ${drink.alcoholPercentage}% ABV',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${drink.standardDrinks.toStringAsFixed(1)} std drinks • ${drink.calories} cal',
                                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  if (drink.id != null) {
                                    Get.dialog(
                                      AlertDialog(
                                        backgroundColor: const Color(0xFF2E3B4E),
                                        title: const Text('Delete Drink', style: TextStyle(color: Colors.white)),
                                        content: const Text(
                                          'Are you sure you want to delete this drink?',
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              controller.deleteDrink(drink.id!);
                                              Get.back();
                                            },
                                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.add_circle, color: Color(0xFF00C4B4), size: 40),
                        onPressed: () {
                          Get.dialog(const AddDrinkDialog());
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // BAC Calculator Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.dialog(const BACCalculatorDialog());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C4B4),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text(
                          'Calculate BAC',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatusItem(String label, String value1, String value2) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 5),
        Text(value1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(value2, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}