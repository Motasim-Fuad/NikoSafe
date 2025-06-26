import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../View_Model/Controller/authentication/vendorController.dart';
import '../../resource/compunents/RoundButton.dart';
import 'widgets/common_widget.dart';

class SignupVendorView extends StatelessWidget {
  final VendorAuthController controller = Get.put(VendorAuthController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          buildInput(
            controller.businessNameController,
            "Venue Name",
            focusNode: controller.businessNameFocus,
            nextFocusNode: controller.emailFocus,
            textInputAction: TextInputAction.next,
            errorText: controller.businessNameError,
          ),
          buildInput(
            controller.emailController,
            "Email",
            focusNode: controller.emailFocus,
            nextFocusNode: controller.phoneFocus,
            textInputAction: TextInputAction.next,
            errorText: controller.emailError,
          ),
          buildInput(
            controller.phoneController,
            "Phone Number",
            focusNode: controller.phoneFocus,
            nextFocusNode: controller.addressFocus,
            textInputAction: TextInputAction.next,
            errorText: controller.phoneError,
          ),
          buildInput(
            controller.addressController,
            "Location",
            focusNode: controller.addressFocus,
            nextFocusNode: controller.descriptionFocus,
            textInputAction: TextInputAction.next,
            errorText: controller.addressError,
          ),
          buildInput(
            controller.descriptionController,
            "Hours of Operation",
            focusNode: controller.descriptionFocus,
            nextFocusNode: controller.capacityFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            errorText: controller.descriptionError,
          ),
          buildInput(
            controller.capacityController,
            "Capacity",
            focusNode: controller.capacityFocus,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            errorText: controller.capacityError,
          ),

          const SizedBox(height: 20),
          _buildPermissionCheckboxes(),
          const SizedBox(height: 20),
          _buildVenueTypeSelection(),
          const SizedBox(height: 20),

          buildUploadBoxForVendor(controller),
          const SizedBox(height: 10),
          buildTermsCheckForVendor(controller),
          const SizedBox(height: 20),

          Obx(() => RoundButton(
            loading: controller.loading.value,
            title: "Verify Email",
            showLoader: true,
            width: double.infinity,
            onPress: () {
              controller.signup();
              FocusScope.of(context).unfocus(); // dismiss keyboard
            },
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPermissionCheckboxes() {
    final permissionLabels = {
      'displayQRCodes': "Agree to display QR codes at Tables/Counters",
      'inAppPromotion': "Interested in-app promotion",
      'allowRewards': "Allow users to earn NikoSafe Rewards at this venue",
      'allowEvents': "Allow venue events on activity feed",
    };

    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: controller.availablePermissions.map((permissionKey) {
        return _buildCheckbox(
          title: permissionLabels[permissionKey] ?? permissionKey,
          value: controller.selectedPermissions.contains(permissionKey),
          onChanged: (val) {
            if (val == true) {
              controller.selectedPermissions.add(permissionKey);
            } else {
              controller.selectedPermissions.remove(permissionKey);
            }
          },
        );
      }).toList(),
    ));
  }


  Widget _buildVenueTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What type of venue do you own?",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),

        // Select All
        Obx(() {
          bool isAllSelected = controller.selectedVenueTypes.length == controller.availableVenueTypes.length;
          return _buildCheckbox(
            title: "Select All Venue Types",
            value: isAllSelected,
            onChanged: (val) {
              if (val == true) {
                controller.selectedVenueTypes.assignAll(controller.availableVenueTypes);
              } else {
                controller.selectedVenueTypes.clear();
              }
            },
          );
        }),

        // List of Venue Type checkboxes
        Obx(() => Column(
          children: controller.availableVenueTypes.map((type) {
            return _buildCheckbox(
              title: type,
              value: controller.selectedVenueTypes.contains(type),
              onChanged: (val) {
                if (val == true) {
                  controller.selectedVenueTypes.add(type);
                } else {
                  controller.selectedVenueTypes.remove(type);
                }
              },
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF00D1B7),
          checkColor: Colors.white,
          side: BorderSide(color: Colors.white),
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
