import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/User/userSearch/explore_item_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import '../../../../View_Model/Controller/user/userSearch/userServiceProviderController/club_event/userBooking_reservationView.dart';

class UserBookReservationView extends StatelessWidget {
  UserBookReservationView({super.key});

  final controller = Get.put(ClubUserBookingReservationController());

  @override
  Widget build(BuildContext context) {
    final dynamic args = Get.arguments;
    if (args == null || args is! List || args.isEmpty || args[0] == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Invalid or missing reservation data",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final ExploreItemModel item = args[0] as ExploreItemModel;

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Book Reservation", style: TextStyle(color: AppColor.primaryTextColor)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: TextStyle(fontSize: 30, color: AppColor.primaryTextColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: controller.nameText,
                  label: "Name",
                  focusNode: controller.nameFocus,
                  validator: (value) => value!.isEmpty ? "Name is required" : null,
                  onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.emailFocus),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: controller.emailText,
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  focusNode: controller.emailFocus,
                  validator: (value) => value!.isEmpty ? "Email is required" : null,
                  onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.phoneFocus),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: controller.phoneText,
                  label: "Phone",
                  keyboardType: TextInputType.phone,
                  focusNode: controller.phoneFocus,
                  validator: (value) => value!.isEmpty ? "Phone is required" : null,
                  onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.guestsFocus),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: controller.guestsText,
                  label: "Number of Guests",
                  keyboardType: TextInputType.number,
                  focusNode: controller.guestsFocus,
                  validator: (value) => value!.isEmpty ? "Guests number required" : null,
                  onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.dateFocus),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => controller.pickDate(context),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: controller.dateText,
                      label: "Select Reservation Date",
                      focusNode: controller.dateFocus,
                      validator: (value) => value!.isEmpty ? "Date is required" : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text("Select Time :", style: TextStyle(color: AppColor.primaryTextColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(
                    controller.timeSlots.length,
                        (index) => Obx(
                          () => RadioListTile<int>(
                        title: Text(controller.timeSlots[index], style: TextStyle(color: AppColor.primaryTextColor)),
                        activeColor: Colors.tealAccent,
                        value: index,
                        groupValue: controller.selectedSlotIndex.value,
                        onChanged: (val) => controller.selectedSlotIndex.value = val!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                RoundButton(
                  width: double.infinity,
                  title: "Send",
                  onPress: controller.submitReservation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
