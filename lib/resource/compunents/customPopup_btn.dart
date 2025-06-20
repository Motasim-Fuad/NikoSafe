import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPopupButton<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T> onSelected;
  final String Function(T)? displayText;
  final Widget Function(T)? customItemBuilder;
  final String hintText;

  const CustomPopupButton({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onSelected,
    this.displayText,
    this.customItemBuilder,
    this.hintText = "Select item",
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<T>(
            value: item,
            child: customItemBuilder != null
                ? customItemBuilder!(item)
                : Text(displayText?.call(item) ?? item.toString()),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedItem != null
                  ? (displayText?.call(selectedItem!) ?? selectedItem.toString())
                  : hintText,
              style: TextStyle(
                fontSize: 16,
                color: selectedItem != null ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}





class PopupController extends GetxController {
  var selected = "".obs;

  void selectItem(String value) {
    selected.value = value;
  }
}





// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'custom_popup_button.dart'; // your custom widget file
// import 'popup_controller.dart';
//
// class PopupExampleView extends StatelessWidget {
//   final PopupController controller = Get.put(PopupController());
//
//   final List<String> items = ['Apple', 'Banana', 'Cherry', 'Date'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Custom Popup Example")),
//       body: Center(
//         child: Obx(() => CustomPopupButton<String>(
//           items: items,
//           selectedItem: controller.selected.value.isEmpty
//               ? null
//               : controller.selected.value,
//           onSelected: controller.selectItem,
//           hintText: "Select Fruit",
//           customItemBuilder: (item) => Row(
//             children: [
//               const Icon(Icons.check_circle_outline, color: Colors.green),
//               const SizedBox(width: 8),
//               Text(item),
//             ],
//           ),
//         )), //copy
//       ),
//     );
//   }
// }
