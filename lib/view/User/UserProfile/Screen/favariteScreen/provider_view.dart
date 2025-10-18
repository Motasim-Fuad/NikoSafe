// view/User/UserSearch/userServiceProvider/provider_favorite_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userSearch/userServiceProviderController/user_service_provider_controller.dart';
import 'package:nikosafe/models/User/userSearch/userServiceProviderModel/user_services_provider.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

class ProviderFavoriteView extends StatelessWidget {
  const ProviderFavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceProviderController controller =Get.put(ServiceProviderController());

    return Container(
      child: Obx(() {
        if (controller.savedProviders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.white.withOpacity(0.5),
                ),
                SizedBox(height: 16),
                Text(
                  'No favorite providers yet',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add providers to your favorites to see them here',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadSavedProviders,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.savedProviders.length,
            itemBuilder: (context, index) {
              final provider = controller.savedProviders[index];
              return _buildFavoriteCard(provider, controller, context);
            },
          ),
        );
      }),
    );
  }

  Widget _buildFavoriteCard(
      ServiceProviderModel provider,
      ServiceProviderController controller,
      BuildContext context,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed(
            RouteName.userServiceProviderDetailView,
            arguments: provider,
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: provider.profilePicture != null
                  ? NetworkImage(provider.profilePicture!)
                  : null,
              backgroundColor: Colors.grey[300],
              child: provider.profilePicture == null
                  ? Icon(Icons.person, size: 30, color: Colors.grey)
                  : null,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.fullName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    provider.designation,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.red, size: 14),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          provider.location,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        provider.averageRating,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        ' (${provider.totalReviews} reviews)',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '\$${provider.desiredPayRate}/hr',
                        style: TextStyle(
                          color: AppColor.limeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () {
                controller.toggleSaveProvider(provider);
              },
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}