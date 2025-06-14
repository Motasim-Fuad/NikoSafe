import '../../../models/Provider/providerHomeModel/task_model.dart' show TaskModel;


class TaskRepository {
  Future<List<TaskModel>> fetchTasks() async {
    return [
      TaskModel(
        service: "Moving Service",
        client: "Sarah Lee",
        date: "25 January 2025",
        time: "2:00 PM",
        location: "Downtown Los Angeles, CA",
      ),
      TaskModel(
        service: "Moving Service",
        client: "Jon",
        date: "25 January 2025",
        time: "5:00 PM",
        location: " Angeles, CA",
      ),
      TaskModel(
        service: "Moving Service",
        client: "Drakes",
        date: "25 January 2025",
        time: "2:00 PM",
        location: "Downtown Los Angeles, CA",
      ),
      TaskModel(
        service: "Moving Service",
        client: "Michal",
        date: "25 January 2025",
        time: "2:00 PM",
        location: "Downtown Los Angeles, CA",
      ),
      // Add more tasks from different clients...
    ];
  }
}
