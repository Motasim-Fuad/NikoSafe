class EmergencyContact {
  String name;
  String number;
  bool isEnabled;

  EmergencyContact({
    required this.name,
    required this.number,
    this.isEnabled = true,
  });
}
