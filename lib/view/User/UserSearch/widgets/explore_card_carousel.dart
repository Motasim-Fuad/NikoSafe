import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/userSearch/explore_item_model.dart';
import '../explore_detail_page.dart';

import 'explore_card_list.dart'; // ✅ Import your custom ExploreCard

class ExploreCardCarousel extends StatelessWidget {
  final List<ExploreItemModel> items;

  const ExploreCardCarousel({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, // Slightly taller to accommodate bottom text
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return ExploreCard(
            item: item,
            width: 300,
            height: 180, // Just the image height part
          );
        },
      ),
    );
  }
}
