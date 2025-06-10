import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../View_Model/toggle_tab_controller.dart';


class RoundedToggleTab extends StatelessWidget {
  final List<String> tabs;
  final ToggleTabController controller;
  final void Function(int)? onTap;

  const RoundedToggleTab({
    super.key,
    required this.tabs,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(30);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF264B52),
        borderRadius: radius,
      ),
      child: Obx(() {
        return Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = controller.selectedIndex.value == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.changeIndex(index);
                  onTap?.call(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2E7D87) : Colors.transparent,
                    borderRadius: radius,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}


//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../components/toggle_tab_button.dart';
// import '../../view_model/toggle_tab_controller.dart';
//
// class SampleScreen extends StatelessWidget {
//   final toggleController = Get.put(ToggleTabController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1C2A2F),
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: RoundedToggleTab(
//                 tabs: ['Reception', 'About'],
//                 controller: toggleController,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: Obx(() {
//                 return toggleController.selectedIndex.value == 0
//                     ? ReceptionPage()
//                     : AboutPage();
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

