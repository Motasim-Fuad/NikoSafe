import 'package:get/get.dart';
import '../../../../../Repositry/userSearch/trainer/trainer_repo.dart';
import '../../../../../models/userSearch/trainer/trainer_model.dart';


class TrainerController extends GetxController {
  final TrainerRepository _trainerRepository = TrainerRepository();

  // Observables
  RxList<TrainerModel> trainerList = <TrainerModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrainers();
  }

  void fetchTrainers() async {
    try {
      isLoading(true);
      final result = await _trainerRepository.fetchTrainers();
      trainerList.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load trainers');
    } finally {
      isLoading(false);
    }
  }

  // Optional: Search functionality
  void searchTrainer(String query) {
    final filtered = _trainerRepository.fetchTrainers().then((trainers) {
      final results = trainers.where((trainer) =>
      trainer.name.toLowerCase().contains(query.toLowerCase()) ||
          trainer.role.toLowerCase().contains(query.toLowerCase())).toList();
      trainerList.assignAll(results);
    });
  }
}
