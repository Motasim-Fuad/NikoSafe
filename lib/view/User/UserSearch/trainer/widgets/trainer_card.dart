import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import '../../../../../models/userSearch/trainer/trainer_model.dart';

class TrainerCard extends StatelessWidget {
  final TrainerModel trainer;

  const TrainerCard({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(trainer.imageUrl),
          ),


          Text(
            trainer.name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            '(${trainer.role})',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
            textAlign: TextAlign.center,
          ),

          Text(
            '${trainer.experience}\n${trainer.rate}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const Spacer(),

          Row(
            children: [
              Text("View Details",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
              SizedBox(width: 8,),

              // RoundButton(width: 40,height: 40,title: "", onPress: (){})

              CircleAvatar(
                backgroundColor: AppColor.iconColor,
                child: IconButton(onPressed: (){
                  Get.toNamed(RouteName.trainerProfile,arguments: trainer);
                }, icon: FaIcon(FontAwesomeIcons.locationArrow,color: Colors.tealAccent,),),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
