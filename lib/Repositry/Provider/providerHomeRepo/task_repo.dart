import 'package:nikosafe/resource/asseets/image_assets.dart';

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
        email: "sarah@example.com",
        phone: "(319) 555-0115",
        clientImage: ImageAssets.userHome_peopleProfile2,
        description: "Lorem ipsum dolor sit amet consectetur...",
        projectImages: [
          ImageAssets.bar1,
          ImageAssets.bar3,
        ],
      ),
      TaskModel(
        service: "Moving Service",
        client: "Jon",
        date: "25 January 2025",
        time: "5:00 PM",
        location: " Angeles, CA",
        email: "sarah@example.com",
        phone: "(319) 555-0115",
        clientImage: ImageAssets.userHome_peopleProfile4,
        description: "Lorem ipsum dolor sit amet consectetur...",
        projectImages: [
          ImageAssets.bar2,
          ImageAssets.bar5,
        ],
      ),
      TaskModel(
        service: "Moving Service",
        client: "Drakes",
        date: "25 January 2025",
        time: "2:00 PM",
        location: "Downtown Los Angeles, CA",
        email: "sarah@example.com",
        phone: "(319) 555-0115",
        clientImage: ImageAssets.userHome_peopleProfile1,
        description: "Lorem ipsum dolor sit amet consectetur...",
        projectImages: [
          ImageAssets.bar3,
          ImageAssets.bar4,
        ],
      ),
      TaskModel(
        service: "Moving Service",
        client: "Michal",
        date: "25 January 2025",
        time: "2:00 PM",
        location: "Downtown Los Angeles, CA",
        email: "sarah@example.com",
        phone: "(319) 555-0115",
        clientImage: ImageAssets.userHome_peopleProfile4,
        description: "Lorem ipsum dolor sit amet consectetur...",
        projectImages: [
          ImageAssets.bar5,
          ImageAssets.bar2,
        ],
      ),
      // Add more tasks from different clients...
    ];
  }
}
