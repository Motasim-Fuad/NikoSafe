
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/User/UserProfile/Screen/favariteScreen/provider_view.dart';

import '../../../../../View_Model/toggle_tab_controller.dart';
import '../../../../../resource/compunents/toggle_tab_button.dart';
import 'event_view.dart';


class FavoritesScreenView extends StatelessWidget {
  final toggleController = Get.put(ToggleTabController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RoundedToggleTab(
                  tabs: ['Event', 'Provider'],
                  controller: toggleController,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  return toggleController.selectedIndex.value == 0
                      ? EventFavoriteView()
                      : ProviderFavoriteView();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
