import 'package:nikosafe/resource/asseets/image_assets.dart';

import '../../models/userSearch/explore_item_model.dart';

class ExploreRepository {
  Future<List<ExploreItemModel>> fetchExploreItems() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      ExploreItemModel(
        id: '1',
        title: 'Luna Lounge',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.restaurant1,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'restaurant',
      ),

      ExploreItemModel(
        id: '2',
        title: 'A ',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.bar1,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'bar',
      ),

      ExploreItemModel(
        id: '3',
        title: 'B',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.restaurant2,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'restaurant',
      ),

      ExploreItemModel(
        id: '4',
        title: 'c',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.club_even1,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'club_event',
      ),

      ExploreItemModel(
        id: '5',
        title: 'd',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.club_even2,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'club_event',
      ),

      ExploreItemModel(
        id: '6',
        title: 'f',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.club_even3,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'club_event',
      ),

      ExploreItemModel(
        id: '7',
        title: 'g',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.bar2,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'bar',
      ),

      ExploreItemModel(
        id: '8',
        title: 'k',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.bar3,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'bar',
      ),

      ExploreItemModel(
        id: '9',
        title: 'h',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.restaurant3,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'restaurant',
      ),

      ExploreItemModel(
        id: '10',
        title: 'kwk',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.restaurant4,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'restaurant',
      ),
      ExploreItemModel(
        id: '11',
        title: 'like',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.bar4,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'bar',
      ), ExploreItemModel(
        id: '12',
        title: 'eid',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.bar5,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'bar',
      ),

      ExploreItemModel(
        id: '13',
        title: 'hey',
        subtitle: 'Downtown LA',
        imageUrl: ImageAssets.club_even4,
        location: 'Downtown LA',
        date: 'May 10',
        time: '8:00 PM - 1:00 AM',
        rating: 4.8,
        category: 'club_event',
      ),
      // Add more...
    ];
  }
}
