import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1), // soft background
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(
            color: Colors.white, // visible text color
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColor.primaryTextColor),
            prefixIcon: Icon(Icons.search, color: AppColor.primaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}





class SearchController extends GetxController {
  var searchText = ''.obs;
  var allItems = <String>[].obs;
  var filteredItems = <String>[].obs;

  void initItems(List<String> items) {
    allItems.value = items;
    filteredItems.value = items;
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    if (value.isEmpty) {
      filteredItems.value = allItems;
    } else {
      filteredItems.value = allItems
          .where((item) => item.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'custom_search_bar.dart'; // your custom widget
// import 'search_controller.dart'; // your controller
//
// class SearchPage extends StatelessWidget {
//   final SearchController controller = Get.put(SearchController());
//   final TextEditingController textController = TextEditingController();
//
//   SearchPage({super.key}) {
//     controller.initItems([
//       'Apple',
//       'Banana',
//       'Orange',
//       'Pineapple',
//       'Grapes',
//       'Mango',
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Custom Search')),
//       body: Column(
//         children: [
//           CustomSearchBar(
//             controller: textController,
//             onChanged: controller.onSearchChanged,
//           ),
//           Expanded(
//             child: Obx(() => ListView.builder(
//               itemCount: controller.filteredItems.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(controller.filteredItems[index]),
//                 );
//               },
//             )),
//           ),
//         ],
//       ),
//     );
//   }
// }
