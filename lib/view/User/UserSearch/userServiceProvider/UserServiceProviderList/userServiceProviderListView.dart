import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userSearch/userServiceProviderController/user_service_provider_controller.dart';

import '../../../../../resource/App_routes/routes_name.dart';
import '../../../../../resource/Colors/app_colors.dart';

class Userserviceproviderlistview extends StatelessWidget {
  final controller = Get.put(UserServiceProviderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2A3C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const BackButton(color: Colors.white),
                  const SizedBox(width: 10),
                  const Text('Service Provider', style: TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: controller.updateSearch,
                      decoration: InputDecoration(
                        hintText: 'Search by name',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF2F3E51),
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    color: Colors.white,
                    onSelected: controller.updateService,
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: '', child: Text('All')),
                      const PopupMenuItem(value: 'Plumber', child: Text('Plumber')),
                      const PopupMenuItem(value: 'Electrician', child: Text('Electrician')),
                      const PopupMenuItem(value: 'Carpenter', child: Text('Carpenter')),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Find Trusted Professionals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 16),
              // Inside the build() method of ServiceProviderView
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }

                  if (controller.filteredProviders.isEmpty) {
                    return const Center(child: Text('No service providers found', style: TextStyle(color: Colors.white)));
                  }

                  return GridView.builder(
                    itemCount: controller.filteredProviders.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final provider = controller.filteredProviders[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F3E51),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(provider.imageUrl),
                              radius: 36,
                            ),
                            const SizedBox(height: 8),
                            Text(provider.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('(${provider.service})', style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text('${provider.experience}  ${provider.rate}', style: const TextStyle(color: Colors.white)),
                            const Spacer(),
                            Row(
                              children: [
                                Text("View Details",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                                CircleAvatar(
                                  backgroundColor: AppColor.iconColor,
                                  child: IconButton(onPressed: (){
                                    Get.toNamed(RouteName.userServiceProviderDetailView ,arguments: provider);
                                  }, icon: FaIcon(FontAwesomeIcons.locationArrow,color: Colors.tealAccent,),),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
