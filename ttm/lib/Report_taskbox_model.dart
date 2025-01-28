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
  final String id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final String date;
  final String location;
  final List<String> pdfUrls;
  final String event;
  final String assignedBy;
  final List<String> attachmentPdfUrls;

  Task({
    required this.id,
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
      date: (json['date']),
      location: json['location'],
      pdfUrls: List<String>.from(json['pdfUrls']),
      event: json['event'],
      assignedBy: json['assignedBy'],
      attachmentPdfUrls: List<String>.from(json['attachmentPdfUrls']), id: json['id'],
    );
  }
}

class Meeting {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final String fromDate;
  final String toDate;
  final String fromTime;
  final String toTime;
  final String location;
  final List<String> pdfUrls;
  final String event;
  final String assignedBy;

  Meeting({
    required this.id,
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
      fromDate: (json['fromDate'] ), // Default to now if null
      toDate: (json['toDate'] ), // Default to now if null
      fromTime: json['fromTime'] ?? '00:00', // Provide a default time
      toTime: json['toTime'] ?? '00:00', // Provide a default time
      location: json['location'] ?? 'Unknown', // Provide a default location
      pdfUrls: List<String>.from(json['pdfUrls'] ?? []), // Default to empty list
      event: json['event'] ?? 'General', // Provide a default event
      assignedBy: json['assignedBy'] ?? 'Unassigned', id: json['id'] ?? '', // Provide a default assigned by
    );
  }
}

final Map<String, dynamic> responseData = {
  'Not Started': {
    'Last 6 months': {
      'tasks': [
        {
          'title': 'Complete Flutter Project',
          'description': 'Finish the task box implementation.',
          'priority': 'High',
          'status': 'Not Started',
          'date': '2023-10-05T10:00:00',
          'location': 'Office',
          'event': 'Task',
          'assignedBy': 'HQ',
          'pdfUrls': ['https://example.com/doc1.pdf'],
          'attachmentPdfUrls': ['https://example.com/attachment1.pdf'],
        },
        {
          'title': 'Prepare Presentation',
          'description': 'Prepare slides for the upcoming meeting.',
          'priority': 'Medium',
          'status': 'Not Started',
          'date': '2023-10-06T10:00:00',
          'location': 'Office',
          'event': 'Meeting',
          'assignedBy': 'Manager',
          'pdfUrls': [],
          'attachmentPdfUrls': [],
        },
      ],
      'meetings': [
        {
          'title': 'Team Standup',
          'description': 'Daily team standup meeting.',
          'priority': 'Low',
          'status': 'Not Started',
          'fromDate': '2023-10-05T09:00:00',
          'toDate': '2023-10-05T09:30:00',
          'location': 'Zoom',
          'event': 'Meeting',
          'assignedBy': 'Team Lead',
        },
      ],
    },
    'Last 3 months': {
      'tasks': [
        {
          'title': 'Complete Flutter Project',
          'description': 'Finish the task box implementation.',
          'priority': 'High',
          'status': 'In Progress',
          'date': '2023-10-05T10:00:00',
          'location': 'Office',
          'event': 'Task',
          'assignedBy': 'HQ',
          'pdfUrls': ['https://example.com/doc1.pdf'],
          'attachmentPdfUrls': ['https://example.com/attachment1.pdf'],
        },
        {
          'title': 'Prepare Presentation',
          'description': 'Prepare slides for the upcoming meeting.',
          'priority': 'Medium',
          'status': 'Not Started',
          'date': '2023-10-06T10:00:00',
          'location': 'Office',
          'event': 'Meeting',
          'assignedBy': 'Manager',
          'pdfUrls': [],
          'attachmentPdfUrls': [],
        },
      ],
      'meetings': [
        {
          'title': 'Team Standup',
          'description': 'Daily team standup meeting.',
          'priority': 'Low',
          'status': 'Not Started',
          'fromDate': '2023-10-05T09:00:00',
          'toDate': '2023-10-05T09:30:00',
          'location': 'Z6oom',
          'event': 'Meeting',
          'assignedBy': 'Team Lead',
        },
      ],
    },
  },
  'Completed': {
    'Last 6 months': {
      'tasks': [
        {
          'title': 'Submit Weekly Report',
          'description': 'Submit the report by the end of the week.',
          'priority': 'Medium',
          'status': 'Completed',
          'date': '2023-10-02T17:00:00',
          'location': 'Remote',
          'event': 'Reporting',
          'assignedBy': 'Manager',
          'pdfUrls': [],
          'attachmentPdfUrls': [],
        },
      ],
      'meetings': [
        {
          'title': 'Project Review',
          'description': 'Review project progress with stakeholders.',
          'priority': 'High',
          'status': 'Completed',
          'fromDate': '2023-10-01T14:00:00',
          'toDate': '2023-10-01T15:00:00',
          'location': 'Conference Room',
          'event': 'Meeting',
          'assignedBy': 'Project Manager',
        },
      ],
    },
    'Last 3 months': {
      'tasks': [
        {
          'title': 'Submit Weekly Report',
          'description': 'Submit the report by the end of the week.',
          'priority': 'Medium',
          'status': 'Completed',
          'date': '2023-10-02T17:00:00',
          'location': 'Remote',
          'event': 'Task',
          'assignedBy': 'Manager',
          'pdfUrls': [],
          'attachmentPdfUrls': [],
        },
      ],
      'meetings': [
        {
          'title': 'Project Review',
          'description': 'Review project progress with stakeholders.',
          'priority': 'High',
          'status': 'Completed',
          'fromDate': '2023-10-01T14:00:00',
          'toDate': '2023-10-01T15:00:00',
          'location': 'Conference Room',
          'event': 'Meeting',
          'assignedBy': 'Project Manager',
        },
      ],
    },
  },
};
