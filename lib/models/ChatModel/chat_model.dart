class ChatModel {
  final String name;
  final String message;
  final String title;
  final String time;
  final String imageUrl;
  final bool isOnline;
  final bool isSentByMe;

  ChatModel({
    required this.name,
    required this.message,
    required this.title,
    required this.time,
    required this.imageUrl,
    this.isOnline = false,
    this.isSentByMe = false,
  });
}
