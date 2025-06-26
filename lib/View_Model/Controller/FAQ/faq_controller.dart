import 'package:get/get.dart';
import '../../../Repositry/FAQ/faq_repo.dart';
import '../../../models/FAQ/faq_model.dart';


class FaqController extends GetxController {
  final faqList = <FaqModel>[].obs;

  final FaqRepository _repo = FaqRepository();

  @override
  void onInit() {
    super.onInit();
    loadFaqs();
  }

  void loadFaqs() {
    faqList.assignAll(_repo.fetchFaqList());
  }

  void toggleExpand(int index) {
    faqList[index].isExpanded = !faqList[index].isExpanded;
    faqList.refresh();
  }
}
