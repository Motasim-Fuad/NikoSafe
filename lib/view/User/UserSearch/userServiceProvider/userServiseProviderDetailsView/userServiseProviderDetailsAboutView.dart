import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../resource/App_routes/routes_name.dart';
import '../../../../../resource/Colors/app_colors.dart';
import '../../../../../resource/asseets/image_assets.dart';
import '../../../../../resource/compunents/RoundButton.dart';

class Userserviseproviderdetailsaboutview extends StatelessWidget {
  const Userserviseproviderdetailsaboutview({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bio",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Text("With over 12 years of coaching experience, Coach John specializes in doubles strategy, footwork mastery, and tournament preparation. An IPTPA-certified instructor and former national champion, he has helped players of all levels refine their technique and elevate their game. Passionate about precision and strategy, Coach John’s training focuses on building confidence, smart shot selection, and court awareness. Whether you're a beginner or a competitive player, his tailored coaching approach ensures measurable improvement and on-court success. 🎾🔥",style: TextStyle(color: Colors.white),),
          SizedBox(height: 10,),
          Text("Achievements ",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Text("Certified IPTPA Level II Coach – Recognized for excellence in player development\nCoached 100+ Players to Tournament Wins – Including state and national titles\nFormer Professional Player – Competed in [League/Tournament Name] at an elite level\nFeatured Speaker at Pickleball Summits – Conducted training workshops and strategy sessions\nTop-Ranked Doubles Player – Dominated competitive circuits\nDeveloped Training Programs for Elite Players – Customized drills and performance-based coaching",style: TextStyle(color: Colors.white),),
          SizedBox(height: 10,),
          Text("Coaching Expertise ",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Text("Doubles Strategy",style: TextStyle(color: Colors.white),),
          Text("TournamentCoach",style: TextStyle(color: Colors.white),),
          SizedBox(height: 10,),
          Text(" Skill Level ",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),

          Text(
            '• Beginner',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 16),
          Text(
            '• Intermediate',
            style: TextStyle(color: Colors.white),
          ),

          SizedBox(height: 10,),

          Card(
            color: AppColor.iconColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Location",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                ),
                Image(image: AssetImage(ImageAssets.location)),

                SizedBox(height: 10,),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
