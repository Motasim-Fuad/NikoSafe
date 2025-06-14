import 'package:get/get.dart';
import '../../../../Repositry/Provider/providerHomeRepo/task_repo.dart';
import '../../../../models/Provider/providerHomeModel/task_model.dart';


class TaskController extends GetxController {
  final TaskRepository _repo = TaskRepository();
  var tasks = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() async {
    tasks.value = await _repo.fetchTasks();
  }
}
