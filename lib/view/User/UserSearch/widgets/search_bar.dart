import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

import '../../../../View_Model/Controller/user/userSearch/explore_controller.dart';

class SearchBarWidget extends StatelessWidget {
  final ExploreController controller;
  SearchBarWidget({required this.controller});


  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: controller.searchByName,
      style: TextStyle(
        color: AppColor.primaryTextColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Search by name...',
        prefixIcon: Icon(Icons.search, color: AppColor.secondaryTextColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        hintStyle: TextStyle(color: AppColor.secondaryTextColor),
      ),
    );
  }

}
