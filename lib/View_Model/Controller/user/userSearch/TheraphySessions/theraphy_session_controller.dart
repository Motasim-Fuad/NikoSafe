import 'package:get/get.dart';
import '../../../../../Repositry/userSearch/TheraphySessions/theraphy_session_repo.dart';

import '../../../../../models/userSearch/theraphy_session/theraphy_session_model.dart';

class TheraphySessionController extends GetxController {
  final _repo = TheraphySessionRepository();

  var sessionList = <TheraphySessionModel>[].obs;
  var filteredSessionList = <TheraphySessionModel>[].obs;
  var isLoading = true.obs;
  var error = ''.obs;

  @override
  void onInit() {
    fetchSessions();
    super.onInit();
  }

  void fetchSessions() async {
    try {
      isLoading.value = true;
      final list = await _repo.fetchTherapySessions();
      sessionList.value = list;
      filteredSessionList.value = list;
    } catch (e) {
      error.value = 'Failed to fetch sessions';
    } finally {
      isLoading.value = false;
    }
  }

  void searchSessions(String query) {
    if (query.isEmpty) {
      filteredSessionList.value = sessionList;
    } else {
      filteredSessionList.value = sessionList.where((session) {
        final nameMatch = session.name.toLowerCase().contains(query.toLowerCase());
        final availabilityMatch = (session.isAvailable ? "available" : "not available")
            .toLowerCase()
            .contains(query.toLowerCase());
        return nameMatch || availabilityMatch;
      }).toList();
    }
  }
}
