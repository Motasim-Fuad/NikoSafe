import 'package:flutter/material.dart';

import '../../../../View_Model/Controller/user/userSearch/explore_controller.dart';

class SearchBarWidget extends StatelessWidget {
  final ExploreController controller;
  SearchBarWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: controller.searchByName,
      decoration: InputDecoration(
        hintText: 'Search by name...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
