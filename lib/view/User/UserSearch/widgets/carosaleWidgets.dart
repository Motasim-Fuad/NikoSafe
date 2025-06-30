import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../View_Model/Controller/user/userSearch/bannerController.dart';

class BannerCarousel extends StatelessWidget {
  final controller = Get.put(BannerController());
  final PageController pageController = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              controller.currentPage.value = index;
            },
            itemCount: controller.events.length,
            itemBuilder: (context, index) {
              final event = controller.events[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        event.image,
                        fit: BoxFit.cover,
                      ),
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            Text(event.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(event.description,
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 16, color: Colors.white),
                                SizedBox(width: 4),
                                Text(event.date,
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(width: 12),
                                Icon(Icons.access_time,
                                    size: 16, color: Colors.white),
                                SizedBox(width: 4),
                                Text(event.time,
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    color: Colors.white),
                                SizedBox(width: 8),
                                Expanded(
                                    child: Text(event.location,
                                        style:
                                        TextStyle(color: Colors.white))),
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
            child: Obx(() => SmoothPageIndicator(
              controller: pageController,
              count: controller.events.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.white,
                dotColor: Colors.white.withOpacity(0.5),
              ),
            )),
          )
        ],
      ),
    ));
  }
}
