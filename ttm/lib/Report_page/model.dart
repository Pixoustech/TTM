import 'dart:ui';

import 'Report_Page.dart';

class ReportData {
  final List<MonthlyTaskData> monthlyData;
  final Map<String, int> taskStatuses;

  ReportData(this.monthlyData, this.taskStatuses);
}
class MonthlyTaskData {
  MonthlyTaskData(this.month, this.notStarted, this.completed, this.inProgress,this.overdue);

  final String month; // Month name
  final double notStarted; // Count of tasks not started
  final double completed; // Count of completed tasks
  final double inProgress; // Count of tasks in progress
  final double overdue;
}

class AttendanceData {
  AttendanceData(this.category, this.value, {this.color});

  final String category; // Attendance category
  final double value; // Attendance value
  final Color? color; // Color for the attendance category
}