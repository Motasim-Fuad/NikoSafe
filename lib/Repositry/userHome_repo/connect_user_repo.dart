import '../../models/userHome/connect_user_model.dart';
import '../../resource/asseets/image_assets.dart';

class ConnectUserRepo {
  static Map<String, dynamic> userJson = {
    "1": {
      "name": "User One",
      "imageUrl": ImageAssets.userHome_peopleProfile4,
      "type": "User",
      "postedImage": [
        ImageAssets.userHome_peopleProfile1,
        ImageAssets.userHome_peopleProfile2,
        ImageAssets.userHome_peopleProfile3,
      ],
      "postCount": 3,
      "connectCount": 45
    },
    "2": {
      "name": "User Two",
      "imageUrl": ImageAssets.userHome_peopleProfile2,
      "type": "User",
      "postedImage": [
        ImageAssets.userHome_peopleProfile4,
        ImageAssets.userHome_userProfile,
      ],
      "postCount": 7,
      "connectCount": 60
    }
  };


  List<ConnectUser> getUsers() {
    return userJson.entries.map((e) => ConnectUser.fromJson(e.value)).toList();
  }
}
