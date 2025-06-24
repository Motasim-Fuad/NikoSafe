class TaskModel {
  final String service;
  final String client;
  final String date;
  final String time;
  final String location;
  final String email;
  final String phone;
  final String clientImage; // asset or network
  final String description;
  final List<String> projectImages; // list of image paths or URLs

  TaskModel({
    required this.service,
    required this.client,
    required this.date,
    required this.time,
    required this.location,
    required this.email,
    required this.phone,
    required this.clientImage,
    required this.description,
    required this.projectImages,
  });
}
