import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/view/User/UserProfile/ViewProfileDetails/all_connects_view.dart';
import '../../../../View_Model/Controller/user/MyProfile/my_profile_details_controller/my_profile_detailsController.dart';

class ProfileDetailsView extends StatelessWidget {
  final controller = Get.put(MyProfileDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF253038),
      appBar: AppBar(
        title: Text('Profile Details', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF253038),
        leading: BackButton(color: Colors.white),
      ),
      body: Obx(() {
        final user = controller.profile.value;
        if (user == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(user.imageUrl),
            ),
            SizedBox(height: 10),
            Text(user.name, style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Text('${user.posts}', style: TextStyle(color: Colors.white)),
                  Text('Posts', style: TextStyle(color: Colors.white54)),
                ]),
                SizedBox(width: 40),
                Column(children: [
                  GestureDetector(
                    onTap: () => Get.to(AllConnectsView()),
                    child: Text('${user.connects}+', style: TextStyle(color: Colors.tealAccent)),
                  ),
                  Text('Connect', style: TextStyle(color: Colors.white54)),
                ])
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(12),
                itemCount: user.galleryImages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (_, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(user.galleryImages[index], fit: BoxFit.cover),
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
