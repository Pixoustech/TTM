import 'dart:convert';

class TaskModel {
  final List<Task> tasks;
  final List<Meeting> meetings;

  TaskModel({required this.tasks, required this.meetings});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    var taskList = json['tasks'] as List? ?? []; // Default to empty list if null
    var meetingList = json['meetings'] as List? ?? []; // Default to empty list if null

    List<Task> tasks = taskList.map((task) => Task.fromJson(task)).toList();
    List<Meeting> meetings = meetingList.map((meeting) => Meeting.fromJson(meeting)).toList();

    return TaskModel(tasks: tasks, meetings: meetings);
  }
}

class Task {
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime date;
  final String location;
  final List<String> pdfUrls;
  final String event;
  final String assignedBy;
  final List<String> attachmentPdfUrls;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.date,
    required this.location,
    required this.pdfUrls,
    required this.event,
    required this.assignedBy,
    required this.attachmentPdfUrls,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      pdfUrls: List<String>.from(json['pdfUrls']),
      event: json['event'],
      assignedBy: json['assignedBy'],
      attachmentPdfUrls: List<String>.from(json['attachmentPdfUrls']),
    );
  }
}

class Meeting {
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime fromDate;
  final DateTime toDate;
  final String fromTime;
  final String toTime;
  final String location;
  final List<String> pdfUrls;
  final String event;
  final String assignedBy;

  Meeting({
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.fromDate,
    required this.toDate,
    required this.fromTime,
    required this.toTime,
    required this.location,
    required this.pdfUrls,
    required this.event,
    required this.assignedBy,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      title: json['title'] ?? '', // Provide default empty string
      description: json['description'] ?? '', // Provide default empty string
      priority: json['priority'] ?? 'Normal', // Provide a default priority
      status: json['status'] ?? 'Scheduled', // Provide a default status
      fromDate: DateTime.parse(json['fromDate'] ?? DateTime.now().toString()), // Default to now if null
      toDate: DateTime.parse(json['toDate'] ?? DateTime.now().toString()), // Default to now if null
      fromTime: json['fromTime'] ?? '00:00', // Provide a default time
      toTime: json['toTime'] ?? '00:00', // Provide a default time
      location: json['location'] ?? 'Unknown', // Provide a default location
      pdfUrls: List<String>.from(json['pdfUrls'] ?? []), // Default to empty list
      event: json['event'] ?? 'General', // Provide a default event
      assignedBy: json['assignedBy'] ?? 'Unassigned', // Provide a default assigned by
    );
  }
}

