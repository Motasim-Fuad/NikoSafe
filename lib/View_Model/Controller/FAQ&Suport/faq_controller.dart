import 'package:get/get.dart';
import 'package:nikosafe/Repositry/FAQ&suport/faq_repo.dart';
import 'package:nikosafe/models/FAQ&Suport/faq_model.dart';


class FaqController extends GetxController {
  final faqList = <FaqModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final FaqRepository _repo = FaqRepository();

  @override
  void onInit() {
    super.onInit();
    loadFaqs();
  }

  Future<void> loadFaqs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repo.fetchFaqList();

      // Filter only active FAQs and sort by order
      final activeFaqs = response.results
          .where((faq) => faq.isActive)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      faqList.assignAll(activeFaqs);

    } catch (e) {
      errorMessage.value = 'Failed to load FAQs: $e';
      print('Error loading FAQs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpand(int index) {
    faqList[index].isExpanded = !faqList[index].isExpanded;
    faqList.refresh();
  }

  Future<void> refreshFaqs() async {
    await loadFaqs();
  }
}