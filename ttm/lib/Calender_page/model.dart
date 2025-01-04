// calendar_model.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// leave_model.dart
class Leave {
  final String groupId;
  final String leaveTypeId;
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;

  Leave({
    required this.groupId,
    required this.leaveTypeId,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      groupId: json['groupId'],
      leaveTypeId: json['leaveTypeId'],
      leaveType: json['leaveType'],
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      reason: json['reason'],
    );
  }
}


class Holiday {
  final String id;
  final String holidayName;
  final DateTime date;
  final bool isActive;
  final DateTime createdDate;

  Holiday({
    required this.id,
    required this.holidayName,
    required this.date,
    required this.isActive,
    required this.createdDate,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    // Parse the date string using the correct format
    DateTime parsedDate = DateFormat("MM/dd/yyyy HH:mm:ss").parse(json['date']);
    DateTime parsedCreatedDate = DateTime.parse(json['createdDate']); // Assuming createdDate is in ISO format

    return Holiday(
      id: json['id'],
      holidayName: json['holidayName'],
      date: parsedDate,
      isActive: json['isActive'],
      createdDate: parsedCreatedDate,
    );
  }
}

/*
// Function to get sample holiday data
Map<DateTime, String> getSampleHolidays() {
  return {
    DateTime(2024, 10, 1): "Labor Day - A day to honor workers.",
    DateTime(2024, 9, 15): "National Day - Celebrate the nation's independence.",
    DateTime(2024, 12, 25): "Christmas - Celebrate with family and friends.",
  };
}*/

class CalendarEventResponse {
  final String status;
  final CalendarEventData data; // Nested class for tasks and meetings
  final String message;

  CalendarEventResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CalendarEventResponse.fromJson(Map<String, dynamic> json) {
    return CalendarEventResponse(
      status: json['status'] ?? '',
      data: CalendarEventData.fromList((json['data'] as List<dynamic>)
          .map((e) => EventData.fromJson(e))
          .toList()),
      message: json['message'] ?? '',
    );
  }
}

class EventData {
  final String id;
  final String userId;
  final String eventId;
  final String eventName;
  final String eventDate; // Date without time
  final String eventDateFromTime; // Date with time
  final String eventDateToTime; // Date with time
  final String fromTime;
  final String toTime;
  final String venue;
  final String location;
  final String priority;
  final String description;
  final String eventType;
  final String eventMode;
  final String statusId;
  final bool isSelfEvent;
  final String createdBy;
  final String createdByUserName;
  final String createdDate;

  EventData({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventDateFromTime,
    required this.eventDateToTime,
    required this.fromTime,
    required this.toTime,
    required this.venue,
    required this.location,
    required this.priority,
    required this.description,
    required this.eventType,
    required this.eventMode,
    required this.statusId,
    required this.isSelfEvent,
    required this.createdBy,
    required this.createdByUserName,
    required this.createdDate,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      userId: json['userId'] ?? '',
      eventId: json['eventId'] ?? '',
      eventName: json['eventName'] ?? '',
      eventDate: json['eventDate'] ?? '',
      eventDateFromTime: json['eventDateFromTime'] ?? '',
      eventDateToTime: json['eventDateToTime'] ?? '',
      fromTime: json['fromTime'] ?? '',
      toTime: json['toTime'] ?? '',
      venue: json['venue'] ?? '',
      location: json['location'] ?? '',
      priority: json['priority'] ?? '',
      description: json['description'] ?? '',
      eventType: json['eventType'] ?? '',
      eventMode: json['eventMode'] ?? '',
      statusId: json['statusId'] ?? '',
      isSelfEvent: json['isSelfEvent'] ?? false,
      createdBy: json['createdBy'] ?? '',
      createdByUserName: json['createdByUserName'] ?? '',
      createdDate: json['createdDate'] ?? '', id: json['id'] ?? '',
    );
  }
}

class CalendarEventData {
  final List<TaskCalender> tasks;
  final List<MeetingCalender> meetings;

  CalendarEventData({
    required this.tasks,
    required this.meetings,
  });

  factory CalendarEventData.fromList(List<EventData> events) {
    List<TaskCalender> tasksList = [];
    List<MeetingCalender> meetingsList = [];

    for (var event in events) {
      if (event.eventType == 'Task') {
        tasksList.add(TaskCalender.fromEventData(event));
      } else if (event.eventType == 'Meeting') {
        meetingsList.add(MeetingCalender.fromEventData(event));
      }
    }

    return CalendarEventData(
      tasks: tasksList,
      meetings: meetingsList,
    );
  }
}

class TaskCalender {
  final String id;
  final String eventId;
  final String eventName;
  final String dueDate; // Use eventDate for the due date
  final String description;
  final String priority;
  final String statusId;
  final String statusName;
  final String eventType;
  final String location;
  final List<String>? pdfUrls;
  final List<String>? attachmentPdfUrls;
  final bool isSelfEvent;

  TaskCalender({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.dueDate,
    required this.description,
    required this.priority,
    required this.statusId,
    required this.eventType,
    required this.statusName,
    required this.location,
    this.pdfUrls,
    this.attachmentPdfUrls,
    required this.isSelfEvent,
  });

  factory TaskCalender.fromEventData(EventData event) {
    return TaskCalender(
      id: event.id,
      eventId: event.eventId,
      eventName: event.eventName,
      dueDate: event.eventDate,
      eventType: event.eventType,
      description: event.description,
      priority: event.priority,
      statusId: event.statusId,
      statusName: '', // Placeholder for future status name
      location: event.location,
      pdfUrls: null,
      attachmentPdfUrls: null,
      isSelfEvent: event.isSelfEvent,
    );
  }
}

class MeetingCalender {
  final String id;
  final String eventId;
  final String eventName;
  final String startDate; // Use eventDateFromTime for start date
  final String endDate; // Use eventDateToTime for end date
  String eventMode;
  final String fromTime;
  final String toTime;
  final String description;
  final String priority;
  final String statusId;
  final String statusName;
  final String venue;
  final String eventType;
  final String location;
  final List<String>? pdfUrls;
  final List<String>? attachmentPdfUrls;
  final bool isSelfEvent;

  MeetingCalender({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.eventType,
    required this.startDate,
    required this.eventMode,
    required this.endDate,
    required this.fromTime,
    required this.toTime,
    required this.description,
    required this.priority,
    required this.statusId,
    required this.statusName,
    required this.venue,
    required this.location,
    this.pdfUrls,
    this.attachmentPdfUrls,
    required this.isSelfEvent,
  });

  factory MeetingCalender.fromEventData(EventData event) {
    return MeetingCalender(
      id: event.id,
      eventId: event.eventId,
      eventMode: event.eventMode,
      eventName: event.eventName,
      eventType: event.eventType,
      startDate: event.eventDateFromTime,
      endDate: event.eventDateToTime,
      fromTime: event.fromTime,
      toTime: event.toTime,
      description: event.description,
      priority: event.priority,
      statusId: event.statusId,
      statusName: '', // Placeholder for future status name
      venue: event.venue,
      location: event.location,
      pdfUrls: null,
      attachmentPdfUrls: null,
      isSelfEvent: event.isSelfEvent,
    );
  }
}

