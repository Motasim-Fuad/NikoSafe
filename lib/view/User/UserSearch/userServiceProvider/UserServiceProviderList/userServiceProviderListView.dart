// view/User/UserSearch/userServiceProvider/service_provider_list_view.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:nikosafe/View_Model/Controller/user/userSearch/userServiceProviderController/user_service_provider_controller.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';


class Userserviceproviderlistview extends StatelessWidget {
  final controller = Get.put(ServiceProviderController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          centerTitle: true,
          title: Text(
            "Service Provider",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Search and Filter Row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: controller.updateSearch,
                        decoration: InputDecoration(
                          hintText: 'Search providers...',
                          hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                          filled: true,
                          fillColor: AppColor.iconColor,
                          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 12),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      color: AppColor.topLinear,
                      onSelected: controller.updateDesignation,
                      itemBuilder: (context) {
                        List<PopupMenuItem<String>> items = [
                          PopupMenuItem(
                            value: '',
                            child: Text(
                              'All',
                              style: TextStyle(
                                color: AppColor.primaryTextColor,
                              ),
                            ),
                          ),
                        ];

                        // Add designations from API
                        for (var designation in controller.designations) {
                          items.add(
                            PopupMenuItem(
                              value: designation.slug,
                              child: Text(
                                designation.name,
                                style: TextStyle(
                                  color: AppColor.primaryTextColor,
                                ),
                              ),
                            ),
                          );
                        }
                        return items;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Find Trusted Professionals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Provider Grid
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (controller.filteredProviders.isEmpty) {
                      return const Center(
                        child: Text(
                          'No service providers found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: controller.refreshData,
                      child: GridView.builder(
                        itemCount: controller.filteredProviders.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          final provider = controller.filteredProviders[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColor.iconColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: provider.profilePicture != null
                                      ? NetworkImage(provider.profilePicture!)
                                      : null,
                                  radius: 36,
                                  backgroundColor: Colors.grey[300],
                                  child: provider.profilePicture == null
                                      ? Icon(Icons.person, size: 36, color: Colors.grey)
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  provider.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '(${provider.designation})',
                                  style: const TextStyle(color: Colors.white70),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      provider.averageRating,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Details",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          RouteName.userServiceProviderDetailView,
                                          arguments: provider,
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.teal.withOpacity(0.2),
                                        radius: 16,
                                        child: FaIcon(
                                          FontAwesomeIcons.arrowRight,
                                          color: Colors.tealAccent,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}