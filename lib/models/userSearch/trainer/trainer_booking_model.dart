class TrainerBookingModel {
  final List<DateTime> dates;
  final List<String> timeSlots;

  TrainerBookingModel({required this.dates, required this.timeSlots});

  Map<String, dynamic> toJson() {
    return {
      "dates": dates.map((d) => d.toIso8601String()).toList(),
      "timeSlots": timeSlots,
    };
  }
}
