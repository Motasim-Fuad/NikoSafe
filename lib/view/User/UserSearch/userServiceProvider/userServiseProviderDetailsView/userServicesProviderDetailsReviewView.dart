import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/User/UserSearch/userServiceProvider/userServiseProviderDetailsView/widgets/taskRequestbottomSheed.dart';

import 'card.dart';

class Userservicesproviderdetailsreviewview extends StatelessWidget {
  const Userservicesproviderdetailsreviewview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BuildInfoCard(
          title: 'Student ',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Name: John Doe"),
              Text("Age: 18"),
            ],
          ),
        ),
        BuildInfoCard(
          title: 'Student ',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Name: John Doe"),
              Text("Age: 18"),
            ],
          ),
        ),

        RoundButton(width: double.infinity,title: "Booking Request", onPress: (){
          Get.bottomSheet( TaskRequestBottomSheet());
        }),

      ],
    );
  }
}
