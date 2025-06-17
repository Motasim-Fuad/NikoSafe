

import '../../../models/Provider/providerTaskModel/provider_task_model.dart';

class ProviderTaskRepo {
  List<ProviderTaskModel> fetchTasks() {
    return [
      ProviderTaskModel(
        customerName: "Jane Cooper",
        task: "Moving Service",
        date: "25 January 2025",
        time: "2:00 PM",
        status: "In Progress",
        amount: "\$200",
      ),
      ProviderTaskModel(
        customerName: "Jane Cooper",
        task: "Moving Service",
        date: "1 February 2025",
        time: "2:00 PM",
        status: "Completed",
        amount: "\$200",
      ),
      ProviderTaskModel(
        customerName: "Jane Cooper",
        task: "Moving Service",
        date: "6 July 2025",
        time: "2:00 PM",
        status: "Completed",
        amount: "\$200",
      ),
      ProviderTaskModel(
        customerName: "Jane Cooper",
        task: "Moving Service",
        date: "30 December 2025",
        time: "2:00 PM",
        status: "Completed",
        amount: "\$200",
      ),
    ];
  }
}
