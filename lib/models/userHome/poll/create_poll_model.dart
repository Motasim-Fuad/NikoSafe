class PollModel {
  String title;
  List<String> options;

  PollModel({required this.title, required this.options});

  Map<String, dynamic> toJson() => {
    "title": title,
    "options": options,
  };
}
