import 'package:flutter/material.dart';

class ProviderProfileModel {
  String? fullName;
  String? jobTitle;
  String? email;
  String? phone;
  DateTime? birthDate;
  List<String>? skills;
  String? payRate;
  String? location;
  String? serviceRadius;
  bool isAvailable;
  DateTimeRange? availabilityDate;
  TimeOfDay? availabilityFromTime;
  TimeOfDay? availabilityToTime;

  ProviderProfileModel({
    this.fullName,
    this.jobTitle,
    this.email,
    this.phone,
    this.birthDate,
    this.skills,
    this.payRate,
    this.location,
    this.serviceRadius,
    this.isAvailable = false,
    this.availabilityDate,
    this.availabilityFromTime,
    this.availabilityToTime,
  });
}
