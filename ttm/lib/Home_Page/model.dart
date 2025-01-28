
class EventResponsestatusbased {
  final String status;
  final EventData data;
  final String message;

  EventResponsestatusbased({required this.status, required this.data, required this.message});

  factory EventResponsestatusbased.fromJson(Map<String, dynamic> json) {
    return EventResponsestatusbased(
      status: json['status'] ?? '',
      data: EventData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}
class EventDatastatusbased {
  final List<Task> tasks;
  final List<Meeting> meetings;

  EventDatastatusbased({required this.tasks, required this.meetings});

  factory EventDatastatusbased.fromJson(Map<String, dynamic> json) {
    var tasksJson = json['tasks'] as List? ?? [];
    var meetingsJson = json['meetings'] as List? ?? [];

    List<Task> tasksList = tasksJson.map((task) => Task.fromJson(task)).toList();
    List<Meeting> meetingsList = meetingsJson.map((meeting) => Meeting.fromJson(meeting)).toList();

    return EventDatastatusbased(
      tasks: tasksList,
      meetings: meetingsList,
    );
  }
}

class EventResponse {
  final String status;
  final EventData data;
  final String message;

  EventResponse({required this.status, required this.data, required this.message});

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      status: json['status'] ?? '',
      data: EventData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}
class EventData {
  final List<Task> tasks;
  final List<Meeting> meetings;

  EventData({required this.tasks, required this.meetings});

  factory EventData.fromJson(Map<String, dynamic> json) {
    var tasksJson = json['tasks'] as List? ?? [];
    var meetingsJson = json['meetings'] as List? ?? [];

    List<Task> tasksList = tasksJson.map((task) => Task.fromJson(task)).toList();
    List<Meeting> meetingsList = meetingsJson.map((meeting) => Meeting.fromJson(meeting)).toList();

    return EventData(
      tasks: tasksList,
      meetings: meetingsList,
    );
  }
}



class Task {
  final String id;
  final String eventName;
  final String eventType;
  final String description;
  final String priority;
  final String statusId;
  final String statusName;
  final String dueDate;
  final String location;
  final List<String>? pdfUrls;
  final List<String>? attachmentPdfUrls;
  final bool isSelfEvent;

  Task({
    required this.id,
    required this.eventName,
    required this.eventType,
    required this.description,
    required this.priority,
    required this.statusId,
    required this.statusName,
    required this.dueDate,
    required this.location,
    this.pdfUrls,
    this.attachmentPdfUrls,
    required this.isSelfEvent,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      eventName: json['eventName'] ?? '',
      eventType: json['eventType'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
      statusId: json['statusId'] ?? '',
      statusName: json['statusName'] ?? '',
      dueDate: json['dueDate'] ?? '',
      location: json['location'] ?? '',
      pdfUrls: json['pdfUrls'] != null ? List<String>.from(json['pdfUrls']) : null,
      attachmentPdfUrls: json['attachmentPdfUrls'] != null ? List<String>.from(json['attachmentPdfUrls']) : null,
      isSelfEvent: json['isSelfEvent'] ?? false,
    );
  }
}

class Meeting {
  final String id;
  final String eventName;
  final String eventType;
  final String eventMode;
  final String description;
  final String priority;
  final String statusId;
  final String statusName;
  final String startDate;
  final String endDate;
  final String fromTime;
  final String toTime;
  final String venue;
  final List<String>? pdfUrls;
  final List<String>? attachmentPdfUrls;
  final bool isSelfEvent;

  Meeting({
    required this.id,
    required this.eventName,
    required this.eventType,
    required this.eventMode,
    required this.description,
    required this.priority,
    required this.statusId,
    required this.statusName,
    required this.startDate,
    required this.endDate,
    required this.fromTime,
    required this.toTime,
    required this.venue,
    required this.pdfUrls,
    required this.attachmentPdfUrls,
    required this.isSelfEvent,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] ?? '',
      eventName: json['eventName'] ?? '',
      eventType: json['eventType'] ?? '',
      eventMode: json['eventMode'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
      statusId: json['statusId'] ?? '',
      statusName: json['statusName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      fromTime: json['fromTime'] ?? '',
      toTime: json['toTime'] ?? '',
      venue: json['venue'] ?? '',
      pdfUrls: json['pdfUrls'] != null ? List<String>.from(json['pdfUrls']) : null,
      attachmentPdfUrls: json['attachmentPdfUrls'] != null ? List<String>.from(json['attachmentPdfUrls']) : null,
      isSelfEvent: json['isSelfEvent'] ?? false,
    );
  }
}
