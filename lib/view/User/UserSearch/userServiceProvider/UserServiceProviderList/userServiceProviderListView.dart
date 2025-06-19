import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userSearch/userServiceProviderController/user_service_provider_controller.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

import '../../../../../resource/App_routes/routes_name.dart';
import '../../../../../resource/Colors/app_colors.dart';
import '../../../../../resource/asseets/image_assets.dart';
import '../../widgets/CustomSectionButton.dart';

class Userserviceproviderlistview extends StatelessWidget {
  final controller = Get.put(UserServiceProviderController());

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          centerTitle: true,
          title: Text("Service Provider",style: TextStyle(color: AppColor.primaryTextColor),),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
             
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
                          fillColor: AppColor.iconColor,
                          prefixIcon: const Icon(Icons.search, color: Colors.white),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      color: AppColor.topLinear,
                      onSelected: controller.updateService,
                      itemBuilder: (context) => [
                         PopupMenuItem(value: '', child: Text('All',style: TextStyle(color: AppColor.primaryTextColor),)),
                         PopupMenuItem(value: 'Plumber', child: Text('Plumber',style: TextStyle(color: AppColor.primaryTextColor),)),
                         PopupMenuItem(value: 'Electrician', child: Text('Electrician',style: TextStyle(color: AppColor.primaryTextColor),)),
                         PopupMenuItem(value: 'Carpenter', child: Text('Carpenter',style: TextStyle(color: AppColor.primaryTextColor),)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                // therephy and taineer


                Row(
                  children: [
                    CustomSectionButton(
                      title: "Therapy sessions",
                      icon:SvgPicture.asset(ImageAssets.therapy),
                      onPress: () {
                        Get.toNamed(RouteName.theraphySessionListView);
                      },
                      height: 40, // 7% of screen height
                      width: width * 0.48,  // 40% of screen width
                      loading: false,
                      textColor: Colors.white,

                    ),

              SizedBox(width: width *0.02,),
                    CustomSectionButton(
                      title: "Trainer",
                      icon:SvgPicture.asset(ImageAssets.trainer),
                      onPress: () {
                        Get.toNamed(RouteName.trainerView);
                      },
                      height: 40,
                      width: width * 0.4,  // 40% of screen width

                      loading: false,
                      textColor: Colors.white,

                    ),
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
                            color:  AppColor.iconColor,
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
                                  Text("View Details",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                  SizedBox(width: 4,),
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
      ),
    );
  }
}
