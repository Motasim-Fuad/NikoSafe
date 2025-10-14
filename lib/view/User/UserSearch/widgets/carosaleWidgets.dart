import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userSearch/bannerController.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerCarousel extends StatelessWidget {
  final controller = Get.put(BannerController());
  final PageController pageController = PageController(viewportFraction: 0.9);

  BannerCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading indicator
      if (controller.isLoading.value && controller.recentEvents.isEmpty) {
        return SizedBox(
          height: 250,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      // Show error message
      if (controller.errorMessage.isNotEmpty && controller.recentEvents.isEmpty) {
        return SizedBox(
          height: 250,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('Failed to load banners', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () => controller.loadRecentBanners(),
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      // Show empty state
      if (controller.recentEvents.isEmpty) {
        return SizedBox(
          height: 250,
          child: Center(
            child: Text('No promotions available', style: TextStyle(color: Colors.grey)),
          ),
        );
      }

      // Show banner carousel (LAST 5 BANNERS)
      return SizedBox(
        height: 250,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                controller.currentPage.value = index;
              },
              itemCount: controller.recentEvents.length,
              itemBuilder: (context, index) {
                final event = controller.recentEvents[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Network Image
                        event.image != null && event.image!.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: event.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        )
                            : Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.image, size: 50),
                        ),
                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacer(),
                              Text(
                                event.bannerTitle ?? 'No Title',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                event.bannerDescription ?? '',
                                style: TextStyle(color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(event.startDate ?? '', style: TextStyle(color: Colors.white)),
                                  SizedBox(width: 12),
                                  Icon(Icons.access_time, size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(event.startTime ?? '', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, color: Colors.white),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(event.location ?? '', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            // Dots Indicator
            Positioned(
              bottom: 12,
              child: SmoothPageIndicator(
                controller: pageController,
                count: controller.recentEvents.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white.withOpacity(0.5),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}