import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPopupButton<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T> onSelected;
  final String Function(T)? displayText;
  final Widget Function(T)? customItemBuilder;
  final String hintText;

  // ✅ New Styling Params
  final Color backgroundColor;
  final Color hintTextColor;
  final Color selectedTextColor;
  final Color itemTextColor;
  final IconData dropdownIcon;

  const CustomPopupButton({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.onSelected,
    this.displayText,
    this.customItemBuilder,
    this.hintText = "Select item",
    this.backgroundColor = const Color(0xFFF9F9F9),
    this.hintTextColor = Colors.grey,
    this.selectedTextColor = Colors.black,
    this.itemTextColor = Colors.black87,
    this.dropdownIcon = Icons.arrow_drop_down,
  }) : super(key: key);

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
                : Text(
              displayText?.call(item) ?? item.toString(),
              style: TextStyle(color: itemTextColor),
            ),
          );
        }).toList();
      },
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      offset: const Offset(0, 45),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                selectedItem != null
                    ? (displayText?.call(selectedItem!) ?? selectedItem.toString())
                    : hintText,
                style: TextStyle(
                  fontSize: 16,
                  color: selectedItem != null ? selectedTextColor : hintTextColor,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Icon(dropdownIcon, color: itemTextColor),
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


//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'custom_popup_button.dart';
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
//           backgroundColor: Colors.white,
//           hintTextColor: Colors.grey.shade500,
//           selectedTextColor: Colors.black87,
//           itemTextColor: Colors.teal,
//           dropdownIcon: Icons.keyboard_arrow_down_rounded,
//           customItemBuilder: (item) => Row(
//             children: [
//               const Icon(Icons.check_circle_outline, color: Colors.green),
//               const SizedBox(width: 8),
//               Text(item, style: TextStyle(color: Colors.teal.shade700)),
//             ],
//           ),
//         )),
//       ),
//     );
//   }
// }
