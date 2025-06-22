import 'package:get/get.dart';
import '../../../../../Repositry/userProfile/user_my_profile_details.dart';
import '../../../../../models/myProfileModel/my_profile_details_model.dart';


class MyProfileDetailsController extends GetxController {
  final profile = Rxn<MyProfileDetailsModel>();

  @override
  void onInit() {
    loadProfile();
    super.onInit();
  }

  void loadProfile() async {
    final repo = MyProfileRepository();
    final json = await repo.getProfileJson();
    profile.value = MyProfileDetailsModel.fromJson(json);
  }
}
