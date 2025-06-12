class BacEntryModel {
  final double bacValue;
  final DateTime timestamp;

  BacEntryModel({required this.bacValue, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'bacValue': bacValue,
    'timestamp': timestamp.toIso8601String(),
  };

  factory BacEntryModel.fromJson(Map<String, dynamic> json) => BacEntryModel(
    bacValue: json['bacValue'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
