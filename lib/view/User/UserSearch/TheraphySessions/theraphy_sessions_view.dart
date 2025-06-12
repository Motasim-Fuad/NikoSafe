import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

import '../../../../View_Model/Controller/user/userSearch/TheraphySessions/theraphy_session_controller.dart';


class TheraphySessionListView extends StatelessWidget {
  final controller = Get.put(TheraphySessionController());

  TheraphySessionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title:  Text("Therapy Sessions",style: TextStyle(color: AppColor.primaryTextColor),),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Search Field
                TextField(
                  onChanged: controller.searchSessions,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by price or availability...',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.search,color: Colors.white,),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),


                const Text(
                  "Expert Psychological Support at Your Fingertips",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                // List of Sessions
                Expanded(
                  child: controller.filteredSessionList.isEmpty
                      ? const Center(child: Text("No sessions found",style: TextStyle(color: Colors.white),))
                      : ListView.builder(
                    itemCount: controller.filteredSessionList.length,
                    itemBuilder: (_, index) {
                      final session = controller.filteredSessionList[index];
                      return GestureDetector(
                        onTap: (){
                          Get.toNamed(RouteName.theraphySessionsDetailsView, arguments:  session);
                        },
                        child: Card(
                          color: AppColor.iconColor,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image with price + availability stacked
                              Stack(

                                children: [
                                  Image.asset(
                                    session.imageUrl,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        session.price,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: session.isAvailable ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        session.isAvailable ? "Available" : "Not Available",
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Session details
                              Padding(
                                padding: const EdgeInsets.all(12.0),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      session.name,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      ;
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
