import 'package:flutter/material.dart';

import '../../../models/userSearch/explore_item_model.dart';
import '../../../resource/Colors/app_colors.dart';
import '../../../resource/compunents/customBackButton.dart';

class ExploreDetailPage extends StatelessWidget {
  final ExploreItemModel item;
  ExploreDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(

          title: Text(item.title,style: TextStyle(color: AppColor.primaryTextColor),),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
            leading: CustomBackButton(),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(item.imageUrl),
              SizedBox(height: 12),
              Text(item.title, style: TextStyle(fontSize: 24,color: AppColor.primaryTextColor)),
              Text(item.location, style: TextStyle(color: AppColor.primaryTextColor)),
              Text("${item.date} • ${item.time}", style: TextStyle(color: AppColor.primaryTextColor)),
              Text("⭐ ${item.rating}", style: TextStyle(color: AppColor.primaryTextColor)),
              Text(item.subtitle, style: TextStyle(color: AppColor.primaryTextColor)),
              Text(item.subtitle, style: TextStyle(color: AppColor.primaryTextColor)),
            ],
          ),
        ),
      ),
    );
  }
}
