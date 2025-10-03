import 'package:nikosafe/resource/asseets/image_assets.dart';

class MyProfileRepository {
  Future<Map<String, dynamic>> getProfileJson() async {
    return {
      "name": "Lukas Wagner",
      "imageUrl": ImageAssets.userHome_userProfile,
      "posts": 72,
      "connects": 500,
      "galleryImages": [
        ImageAssets.bar1,
        ImageAssets.bar2,
        ImageAssets.bar3,
        ImageAssets.bar4,
        ImageAssets.bar5,
        ImageAssets.club_even2,
        ImageAssets.club_even1,
        ImageAssets.restaurant1,
        ImageAssets.restaurant3,

      ],
    };
  }
}
