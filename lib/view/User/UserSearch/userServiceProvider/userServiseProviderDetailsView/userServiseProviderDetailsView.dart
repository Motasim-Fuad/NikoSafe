import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userSearch/userServiceProviderController/user_service_provider_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/User/UserSearch/userServiceProvider/userServiseProviderDetailsView/userServicesProviderDetailsReviewView.dart';
import 'package:nikosafe/view/User/UserSearch/userServiceProvider/userServiseProviderDetailsView/userServiseProviderDetailsAboutView.dart';
import '../../../../../View_Model/toggle_tab_controller.dart';
import '../../../../../models/userSearch/userServiceProviderModel/user_services_provider.dart';
import '../../../../../resource/compunents/toggle_tab_button.dart';


class UserServiceProviderDetailView extends StatelessWidget {
  final UserServiceProvider provider = Get.arguments;
  final toggleController = Get.put(ToggleTabController());
  final providerController = Get.put(UserServiceProviderController());

  UserServiceProviderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Service Provider Detail'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            Obx(() => IconButton(
              onPressed: () {
                providerController.toggleFavorite(provider);
              },
              icon: Icon(
                providerController.isFavorite(provider.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: providerController.isFavorite(provider.id)
                    ? Colors.red
                    : Colors.white,
              ),
            )),
          ],
        ),
        body: Column(
          children: [
            // Top section
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(provider.imageUrl),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    provider.service,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Experience: ${provider.experience}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Rate: ${provider.rate}',
                    style: const TextStyle(color: Colors.white),
                  ),

                  SizedBox(height: 10,),

                  RoundButton(width: 200,height:40,title: "Massage", onPress: (){

                  }),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RoundedToggleTab(
                      tabs: ['About', 'Review'],
                      controller: toggleController,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom scrollable section
            Expanded(
              child: ClipPath(
                clipper: TopRoundedClipper(),
                child: Container(
                  color: Color(0xff264953),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          toggleController.selectedIndex.value == 0
                              ? Userserviseproviderdetailsaboutview()
                              : Userservicesproviderdetailsreviewview(item: provider),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 30.0;

    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
