import 'package:get/get.dart';
import 'package:nikosafe/models/User/myProfileModel/user_history_purchase_model.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';


class UserPurchaseHistoryController extends GetxController {
  RxList<UserHistoryPurchaseModel> purchases = <UserHistoryPurchaseModel>[
    UserHistoryPurchaseModel(
      imageUrl: ImageAssets.bar5,
      itemName: 'Violin Strings Set',
      date: '2025-06-01',
      time: '3:45 PM',
      amount: 20.49,
      isDelivered: true,
    ),
    UserHistoryPurchaseModel(
      imageUrl: ImageAssets.bar3,
      itemName: 'Sheet Music - Beethoven',
      date: '2025-06-05',
      time: '2:10 PM',
      amount: 15.99,
      isDelivered: false,
    ),
  ].obs;
}
