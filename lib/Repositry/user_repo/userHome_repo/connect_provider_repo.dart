

import 'package:nikosafe/models/User/userHome/connect_provider_model.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';

class ConnectProviderRepo {
  static Map<String, dynamic> providerJson = {
    "1": {
      "name": "Provider One",
      "imageUrl": ImageAssets.userHome_peopleProfile3,
      "type": "Service Provider",
      "postedImage": [
        ImageAssets.userHome_userProfile,
        ImageAssets.userHome_peopleProfile1,
      ],
      "postCount": 5,
      "connectCount": 120
    },
    "2": {
      "name": "Provider Two",
      "imageUrl": ImageAssets.userHome_peopleProfile1,
      "type": "Service Provider",
      "postedImage": [
        ImageAssets.userHome_peopleProfile2,
        ImageAssets.userHome_peopleProfile3,
      ],
      "postCount": 8,
      "connectCount": 95
    },
  };


  List<ConnectProvider> getProviders() {
    return providerJson.entries.map((e) => ConnectProvider.fromJson(e.value)).toList();
  }
}
