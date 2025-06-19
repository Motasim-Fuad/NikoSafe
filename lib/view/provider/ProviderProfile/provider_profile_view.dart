import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/view/provider/ProviderProfile/Screen/ProviderEditProfile/edit_profile.dart';
import '../../../View_Model/Controller/authentication/authentication_view_model.dart';


class ProviderProfileView extends StatelessWidget {
  final controller = Get.put(AuthViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Profile", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: false,

          actions:  [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(onPressed: (){
                Get.toNamed(RouteName.userSettingsView);
              }, icon:Icon(Icons.settings,color: Colors.white,) ),
            ),
          ],
        ),
        // body: Obx(() {
        // //  final user = controller.profile.value;
        //   return
        //    ;
        // }),

        body:  SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(ImageAssets.userHome_peopleProfile4),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${"99"} Points",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "lucky",
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {

                },
                child: const Text("Plumber", style: TextStyle(color: Colors.cyan)),
              ),
              const SizedBox(height: 20),



              _buildTile(ImageAssets.profile_edit, "Edit Profile Details", () {
                // Get.toNamed(RouteName.userEditProfileView);
                Get.to(ProviderEditProfileView());
              }),
              _buildTile(ImageAssets.profile_withdrow, "Withdraws", () {
                Get.toNamed(RouteName.providerWithDrawCompleteView);
              }),

              _buildTile(ImageAssets.profile_bank, "Bank Details", () {
                Get.toNamed(RouteName.providerBankDetailsView);
              }),
              _buildTile(ImageAssets.profile_suport, "Support", () {
                Get.toNamed(RouteName.porviderSupportView);
              }),
              _buildTile(ImageAssets.profile_privacy, "Privacy Policy", () {
                Get.toNamed(RouteName.userPrivacyPolicy);
              }),
              _buildTile(ImageAssets.profile_tarms, "Terms & Conditions", () {
                Get.toNamed(RouteName.userTearmsConditions);
              }),
              _buildTile(ImageAssets.profile_about, "About Us", () {
                Get.toNamed(RouteName.userAboutUs);
              }),

              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  controller.logout();
                },
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Log Out", style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(dynamic icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.iconColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColor.iconColor,
              child: icon is String
                  ? SvgPicture.asset(icon, height: 30, width: 30, color: Color(0xff0191bd))
                  : Icon(icon, color: Color(0xff0191bd)),
            ),
            title: Text(title, style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
          ),
        ),
      ),
    );
  }

}
