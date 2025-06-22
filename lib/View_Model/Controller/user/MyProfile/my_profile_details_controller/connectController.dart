import 'package:get/get.dart';
import '../../../../../models/myProfileModel/my_profile_details_model.dart';
import '../../../../../resource/asseets/image_assets.dart';

class ConnectsController extends GetxController {
  RxList<MyProfileDetailsModel> connects = <MyProfileDetailsModel>[].obs;

  @override
  void onInit() {
    fetchConnects();
    super.onInit();
  }

  void fetchConnects() {
    connects.value = List.generate(
      8,
          (index) => MyProfileDetailsModel(
        name: 'Lukas Wagner $index',
        imageUrl: ImageAssets.userHome_userProfile,
        posts: 32,
        connects: 100,
        galleryImages: [
          ImageAssets.bar1,
          ImageAssets.bar2,
        ],
      ),
    );
  }

  void removeConnect(int index) {
    connects.removeAt(index);
  }
}
