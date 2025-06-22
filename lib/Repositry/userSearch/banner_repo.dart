// repository/event_repository.dart
import 'package:nikosafe/resource/asseets/image_assets.dart';

import '../../models/userSearch/bannerModel.dart';


class BannerRepository {
  List<BannerModel> fetchEvents() {
    return [
      BannerModel(
        title: "Celebrate Taco Tuesday!",
        description: "Buy 1 Get 1 Free on Tacos from 5–9 PM",
        date: "May 10",
        time: "8:00 PM – 1:00 AM",
        location: "Luna Lounge, Downtown LA",
        image: ImageAssets.club_even2,
      ),
      BannerModel(
        title: "Summer Beach Party",
        description: "Music, Dance & Fireworks",
        date: "June 15",
        time: "4:00 PM – 11:00 PM",
        location: "Santa Monica Beach",
        image: ImageAssets.club_even3,
      ),

      BannerModel(
        title: "Summer Beach Party",
        description: "Music, Dance & Fireworks",
        date: "June 15",
        time: "4:00 PM – 11:00 PM",
        location: "Santa Monica Beach",
        image: ImageAssets.club_even1,
      ),

      BannerModel(
        title: "Summer Beach Party",
        description: "Music, Dance & Fireworks",
        date: "June 15",
        time: "4:00 PM – 11:00 PM",
        location: "Santa Monica Beach",
        image: ImageAssets.club_even4,
      ),
      BannerModel(
        title: "Summer Beach Party",
        description: "Music, Dance & Fireworks",
        date: "June 15",
        time: "4:00 PM – 11:00 PM",
        location: "Santa Monica Beach",
        image: ImageAssets.bar1,
      ),
    ];
  }
}
