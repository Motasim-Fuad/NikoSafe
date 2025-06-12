import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../View_Model/toggle_tab_controller.dart';
import '../../../../resource/compunents/toggle_tab_button.dart';
import 'controller.dart';

class BacChartView extends StatelessWidget {
  final BacChartController controller = Get.put(BacChartController());
  final ToggleTabController toggleTabController = Get.put(ToggleTabController());


  final TextEditingController volumeController = TextEditingController(); // ml
  final TextEditingController abvController = TextEditingController();    // %
  final TextEditingController weightController = TextEditingController(); // kg
  final TextEditingController hoursController = TextEditingController();  // hours

  final RxString gender = "male".obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title:  Text('BAC Tracker Chart',style: TextStyle(color: AppColor.primaryTextColor),),
              centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,

        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RoundedToggleTab(
                  tabs: ['HOURLY', 'WEEKLY', 'MONTHLY'], // Replace with your BacViewMode names
                  controller: toggleTabController,       // You’ll define this below
                  onTap: (index) {
                    controller.selectedMode.value = BacViewMode.values[index];
                  },
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 300,
                child: Obx(() {
                  final data = controller.getChartData();
                  return SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelStyle: TextStyle(color: Colors.white), // X-axis label color
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: TextStyle(color: Colors.white), // Y-axis label color
                    ),
                    title: ChartTitle(
                      text: 'BAC Overview',
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<Map<String, dynamic>, String>(
                        dataSource: data,
                        xValueMapper: (datum, _) => datum['x'],
                        yValueMapper: (datum, _) => (datum['y'] as num?)?.toDouble() ?? 0.0,
                        pointColorMapper: (datum, _) => datum['color'] as Color,
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                        color: Color(0x991DE3D1),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 20,),
              Column(
                children: [
                  Row(

                    children: [
                      Container(height: 10,width: 10,decoration: BoxDecoration(color: Color(0xff649e3f)),),
                      SizedBox(width: 6,),
                      Text("Safe Zone",style: TextStyle(color: AppColor.primaryTextColor),),
                      SizedBox(width: 20,),
                      Text("0.00%–0.03%",style: TextStyle(color: AppColor.primaryTextColor)),
                    ],
                  ),

                  Row(

                    children: [
                      Container(height: 10,width: 10,decoration: BoxDecoration(color: Color(
                          0xffece108)),),
                      SizedBox(width: 6,),
                      Text("Caution",style: TextStyle(color: AppColor.primaryTextColor)),
                      SizedBox(width: 20,),
                      Text("0.04%–0.07%",style: TextStyle(color: AppColor.primaryTextColor)),
                    ],
                  ),

                  Row(

                    children: [
                      Container(height: 10,width: 10,decoration: BoxDecoration(color: Color(
                          0xfff33636)),),
                      SizedBox(width: 6,),
                      Text("Danger",style: TextStyle(color: AppColor.primaryTextColor)),
                      SizedBox(width: 20,),
                      Text(">0.08%",style: TextStyle(color: AppColor.primaryTextColor)),
                    ],
                  ),


                ],
              ),


              const SizedBox(height: 30),

              const Text("Calculate BAC", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white)),
              SizedBox(height: 10,),
              CustomTextField(
                controller: volumeController,
                hintText: "Volume of alcohol consumed (ml)",
                keyboardType: TextInputType.number,
                fillColor: AppColor.iconColor,
              ),
              SizedBox(height: 10,),
              CustomTextField(
                controller: abvController,
                hintText: "Alcohol percentage (ABV)",
                keyboardType: TextInputType.number,
                fillColor: AppColor.iconColor,
              ),
              SizedBox(height: 10,),
              CustomTextField(
                controller: weightController,
                hintText: "Your weight (kg)",
                keyboardType: TextInputType.number,
                fillColor: AppColor.iconColor,
              ),
              SizedBox(height: 10,),
              CustomTextField(
                controller: hoursController,
                hintText: "Hours since drinking",
                keyboardType: TextInputType.number,
                fillColor: AppColor.iconColor,
              ),

              const SizedBox(height: 10),

              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'male',
                    groupValue: gender.value,
                    onChanged: (val) => gender.value = val!,
                  ),
                  const Text("Male",style: TextStyle(color: Colors.white),),
                  Radio<String>(
                    value: 'female',
                    groupValue: gender.value,
                    onChanged: (val) => gender.value = val!,
                  ),
                  const Text("Female",style: TextStyle(color: Colors.white),),
                ],
              )),

              Center(
                child: RoundButton(width: double.infinity,title: "Calculate BAC", onPress: (){
                      final volume = double.tryParse(volumeController.text) ?? 0;
                      final abv = double.tryParse(abvController.text) ?? 0;
                      final weightKg = double.tryParse(weightController.text) ?? 0;
                      final hours = double.tryParse(hoursController.text) ?? 0;

                      if (volume > 0 && abv > 0 && weightKg > 0) {
                        final alcoholOz = volume * (abv / 100.0) * 0.789 * 0.033814;
                        final weightLb = weightKg * 2.20462;
                        final r = gender.value == 'male' ? 0.73 : 0.66;
                        final bac = ((alcoholOz * 5.14) / (weightLb * r)) - (0.015 * hours);
                        final result = bac < 0.0 ? 0.0 : bac;

                        controller.addEntry(bac);

                        volumeController.clear();
                        abvController.clear();
                        weightController.clear();
                        hoursController.clear();
                        Get.snackbar("BAC Result", "Estimated BAC: ${bac.toStringAsFixed(4)}",
                            backgroundColor: Colors.black87,
                            colorText: Colors.white);
                      } else {
                        Get.snackbar("Error", "Please fill all fields with valid values",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white);
                      }
                }),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
