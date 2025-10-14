import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nikosafe/View_Model/Controller/user/userSearch/bannerController.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class BannerPromotionsView extends StatelessWidget {
  final controller = Get.put(BannerController());

  BannerPromotionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("All Promotions", style: TextStyle(color: AppColor.primaryTextColor)),
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: Obx(() {
          // Show loading indicator
          if (controller.isLoading.value && controller.events.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          // Show error message
          if (controller.errorMessage.isNotEmpty && controller.events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Failed to load promotions',
                      style: TextStyle(color: AppColor.primaryTextColor, fontSize: 18)),
                  SizedBox(height: 8),
                  Text(controller.errorMessage.value,
                      style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadAllBanners(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show empty state
          if (controller.events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No promotions available',
                      style: TextStyle(color: AppColor.primaryTextColor, fontSize: 18)),
                ],
              ),
            );
          }

          // Show ALL banners
          return RefreshIndicator(
            onRefresh: () => controller.refreshBanners(),
            child: ListView.builder(
              itemCount: controller.events.length,
              itemBuilder: (context, index) {
                final event = controller.events[index];
                return Card(
                  margin: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        // Network Image
                        event.image != null && event.image!.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: event.image!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        )
                            : Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[300],
                          child: Icon(Icons.image, size: 50),
                        ),
                        // Overlay gradient
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        // Text on image
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.bannerTitle ?? 'No Title',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(1, 1)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${event.startDate ?? ''} • ${event.location ?? ''}",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(blurRadius: 3, color: Colors.black45, offset: Offset(1, 1)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}