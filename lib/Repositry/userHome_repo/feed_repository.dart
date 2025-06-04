import 'package:nikosafe/resource/asseets/image_assets.dart';

import '../../models/userHome/post_model.dart';


class FeedRepository {
  Future<List<PostModel>> fetchFeedPosts() async {
    await Future.delayed(Duration(seconds: 1)); // simulate delay
    return [
      PostModel(
        username: 'John Doe',
        userImage: ImageAssets.userHome_userProfile,
        content: 'Nam posuere elit a facilisis hendrerit...',
        imageUrl: ImageAssets.userHome_peoplePostImage1,
        date: DateTime.now(),
        likes: 100,
        comments: 100,
      ),
      PostModel(
        username: 'Lukas Wagner Is In Barx',
        userImage: ImageAssets.userHome_peopleProfile1,
        content: 'Try the Mojito! 🔥',
        imageUrl: ImageAssets.userHome_peoplePostImage2,
        date: DateTime(2024, 4, 1),
        likes: 10,
        comments: 2,
        location: 'View Bar',
        isMap: true,
      ),

      PostModel(
        username: 'Josef',
        userImage: ImageAssets.userHome_peopleProfile2,
        content: 'Try the Mojito! 🔥',
        imageUrl: ImageAssets.userHome_peoplePostImage3,
        date: DateTime(2024, 4, 1),
        likes: 10,
        comments: 2,
        location: 'View Bar',
        isMap: true,
      ),

      PostModel(
        username: 'Michal',
        userImage: ImageAssets.userHome_peopleProfile3,
        content: 'Try the Mojito! 🔥',
        imageUrl: ImageAssets.userHome_peoplePostImage4,
        date: DateTime(2024, 4, 1),
        likes: 10,
        comments: 2,
        location: 'View Bar',
        isMap: true,
      ),
    ];
  }
}
