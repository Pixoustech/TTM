// calendar_model.dart

import 'package:flutter/material.dart';

class LeaveStatus {
  final DateTime fromDate;
  final DateTime toDate;
  final String status;
  final String title;
  final String description;

  LeaveStatus({
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.title,
    required this.description,
  });
}

// Model for holidays
class Holiday {
  final DateTime date;
  final String description;

  Holiday({required this.date, required this.description});
}

// Function to get sample leave statuses
List<LeaveStatus> getSampleLeaveStatuses() {
  return [
    LeaveStatus(
      fromDate: DateTime(2024, 10, 1),
      toDate: DateTime(2024, 10, 1),
      status: "Approved",
      title: "Design",
      description: 'Going to Hospital',
    ),
    LeaveStatus(
      fromDate: DateTime(2024, 9, 15),
      toDate: DateTime(2024, 9, 16),
      status: "Rejected",
      title: "App develop",
      description: 'Going to Hospital',
    ),
    LeaveStatus(
      fromDate: DateTime(2024, 12, 25),
      toDate: DateTime(2024, 12, 30),
      status: "Waiting",
      title: "App develop",
      description: 'Going to Hospital',
    ),
  ];
}

// Function to get sample holiday data
Map<DateTime, String> getSampleHolidays() {
  return {
    DateTime(2024, 10, 1): "Labor Day - A day to honor workers.",
    DateTime(2024, 9, 15): "National Day - Celebrate the nation's independence.",
    DateTime(2024, 12, 25): "Christmas - Celebrate with family and friends.",
  };
}