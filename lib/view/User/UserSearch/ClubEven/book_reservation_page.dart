import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nikosafe/models/userSearch/explore_item_model.dart'; // import your model
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/utils/utils.dart';

class UserBookReservationView extends StatelessWidget {
  UserBookReservationView({super.key});

  final TextEditingController nameText = TextEditingController();
  final TextEditingController phoneText = TextEditingController();
  final TextEditingController emailText = TextEditingController();
  final TextEditingController guestsText = TextEditingController();
  final TextEditingController dateText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ✅ Fetch the ExploreItemModel argument
    final ExploreItemModel item = Get.arguments[0];

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Book Reservation",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  style: TextStyle(
                      fontSize: 30,
                      color: AppColor.primaryTextColor,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CustomTextField(controller: nameText, label: "Name"),
              const SizedBox(height: 8),
              CustomTextField(controller: emailText, label: "Email"),
              const SizedBox(height: 8),
              CustomTextField(controller: phoneText, label: "Phone"),
              const SizedBox(height: 8),
              CustomTextField(controller: guestsText, label: "Number of Guests"),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    dateText.text = formattedDate;
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: dateText,
                    label: "Select Reservation Date",
                  ),
                ),
              ),

                SizedBox(height: 40,),
              RoundButton(width: double.infinity,title: "Send", onPress: (){
                Utils.successSnackBar("Book Reservation", "Book Reservation Submit Successfully");
                nameText.clear();
                emailText.clear();
                phoneText.clear();
                guestsText.clear();
                dateText.clear();
              }),

            ],
          ),
        ),

      ),
    );
  }
}
