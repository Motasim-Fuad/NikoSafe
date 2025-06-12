import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/view/User/UserSearch/userServiceProvider/userServiseProviderDetailsView/widgets/taskRequestbottomSheed.dart';

import '../../../../../resource/compunents/RoundButton.dart';
import 'card.dart';

class Userserviseproviderdetailsaboutview extends StatelessWidget {
  const Userserviseproviderdetailsaboutview({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          BuildInfoCard(
            title: 'Student Details',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Name: John Doe",style: TextStyle(color: Colors.white),),
                Text("Age: 18",style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
      
          BuildInfoCard(
            title: 'Student Details',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Name: John Doe",style: TextStyle(color: Colors.white),),
                Text("Age: 18",style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          BuildInfoCard(
            title: 'Student Details',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Name: John Doe",style: TextStyle(color: Colors.white),),
                Text("Age: 18",style: TextStyle(color: Colors.white)),
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
