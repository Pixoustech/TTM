import 'dart:ui';

class Report {
  final Last6Months last6Months;
  final Last3Months last3Months;

  Report({required this.last6Months, required this.last3Months});
}

class Last6Months {
  final OverallCounts overallCounts;
  final Map<String, MonthlyTaskCounts> monthlyTaskCounts;
  final Attendance attendance;

  Last6Months({required this.overallCounts, required this.monthlyTaskCounts, required this.attendance});
}

class Last3Months {
  final OverallCounts overallCounts;
  final Map<String, MonthlyTaskCounts> monthlyTaskCounts;
  final Attendance attendance;

  Last3Months({required this.overallCounts, required this.monthlyTaskCounts, required this.attendance});
}

class OverallCounts {
  final int notStarted;
  final int inProgress;
  final int completed;
  final int overdue;

  OverallCounts({required this.notStarted, required this.inProgress, required this.completed, required this.overdue});
}

class MonthlyTaskCounts {
  final int notStarted;
  final int inProgress;
  final int completed;
  final int overdue;

  MonthlyTaskCounts({required this.notStarted, required this.inProgress, required this.completed, required this.overdue});
}

class Attendance {
  final int absentCount;
  final int presentCount;
  final String absentPercentage;
  final String presentPercentage;
  final String totalPercentage;

  Attendance({required this.absentCount, required this.presentCount, required this.absentPercentage, required this.presentPercentage, required this.totalPercentage});
}

class MonthlyTaskData {
  final String month;
  final int notStarted;
  final int inProgress;
  final int completed;
  final int overdue;

  MonthlyTaskData(this.month, this.notStarted, this.inProgress, this.completed, this.overdue);
}

class AttendanceData {
  final String category;
  final int value; // Assuming value is of type int for counts
  final Color color;

  AttendanceData(this.category, this.value, {required this.color});
}
final Report sampleReportData = Report(
  last6Months: Last6Months(
    overallCounts: OverallCounts(
      notStarted: 23,
      inProgress: 42,
      completed: 35,
      overdue: 9,
    ),
    monthlyTaskCounts: {
      'jan': MonthlyTaskCounts(notStarted: 5, inProgress: 8, completed: 6, overdue: 2),
      'feb': MonthlyTaskCounts(notStarted: 3, inProgress: 7, completed: 5, overdue: 1),
      'march': MonthlyTaskCounts(notStarted: 2, inProgress: 6, completed: 4, overdue: 3),
      'april': MonthlyTaskCounts(notStarted: 4, inProgress: 9, completed: 5, overdue: 0),
      'may': MonthlyTaskCounts(notStarted: 6, inProgress: 7, completed: 8, overdue: 2),
      'june': MonthlyTaskCounts(notStarted: 3, inProgress: 5, completed: 7, overdue: 1),
    },
    attendance: Attendance(
      absentCount: 67,
      presentCount: 21,
      absentPercentage: "24%",
      presentPercentage: "76%",
      totalPercentage: "100%",
    ),
  ),
  last3Months: Last3Months(
    overallCounts: OverallCounts(
      notStarted: 6,
      inProgress: 18,
      completed: 9,
      overdue: 4,
    ),
    monthlyTaskCounts: {
      'october': MonthlyTaskCounts(notStarted: 2, inProgress: 6, completed: 4, overdue: 1),
      'november': MonthlyTaskCounts(notStarted: 3, inProgress: 7, completed: 2, overdue: 2),
      'december': MonthlyTaskCounts(notStarted: 1, inProgress: 5, completed: 3, overdue: 1),
    },
    attendance: Attendance(
      absentCount: 67,
      presentCount: 50,
      absentPercentage: "24%",
      presentPercentage: "76%",
      totalPercentage: "76%",
    ),
  ),
);