// Path: View/user/userHome/connectTabView.dart
// Copy this ENTIRE file

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customSearchBar.dart';
import '../../../View_Model/Controller/user/userHome/connectController.dart';

class ConnectTabView extends StatefulWidget {
  const ConnectTabView({super.key});

  @override
  State<ConnectTabView> createState() => _ConnectTabViewState();
}

class _ConnectTabViewState extends State<ConnectTabView> {
  final ConnectController controller = Get.put(ConnectController());
  late TextEditingController searchFieldController;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    searchFieldController = TextEditingController();
    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreUsers();
      }
    });
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchBar(
          controller: searchFieldController,
          onChanged: (value) => controller.updateSearch(value),
        ),

        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.currentPage.value == 1) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (controller.filteredConnections.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      controller.searchText.value.isEmpty
                          ? Icons.people_outline
                          : Icons.search_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.searchText.value.isEmpty
                          ? 'No users available'
                          : 'No users found',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => controller.refreshList(),
                      child: const Text('Refresh', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.refreshList(),
              color: Colors.white,
              backgroundColor: AppColor.iconColor,
              child: GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.filteredConnections.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.filteredConnections.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  final connection = controller.filteredConnections[index];
                  final buttonText = controller.getConnectionButtonText(
                      connection.friendshipStatus);
                  final isButtonEnabled = controller.isConnectionButtonEnabled(
                      connection.friendshipStatus);

                  return GestureDetector(
                    onTap: () => controller.goToProfile(connection),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.iconColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: connection.profilePicture != null
                                ? NetworkImage(connection.imageUrl)
                                : const AssetImage('assets/images/peopleProfile4.jpg')
                            as ImageProvider,
                            radius: 30,
                            backgroundColor: Colors.grey[800],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              connection.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          RoundButton(
                            onPress: isButtonEnabled
                                ? () {
                              controller.sendFriendRequest(
                                  connection.id, connection.name);
                            }
                                : () {},
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.35,
                            title: buttonText,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}