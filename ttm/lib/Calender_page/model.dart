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
  final CalendarEventData data;
  final String message;

  CalendarEventResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CalendarEventResponse.fromJson(Map<String, dynamic> json) {
    return CalendarEventResponse(
      status: json['status'] ?? '',
      data: CalendarEventData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
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

  factory CalendarEventData.fromJson(Map<String, dynamic> json) {
    var tasksJson = json['tasks'] as List? ?? [];
    var meetingsJson = json['meetings'] as List? ?? [];

    List<TaskCalender> tasksList =
    tasksJson.map((task) => TaskCalender.fromJson(task)).toList();
    List<MeetingCalender> meetingsList =
    meetingsJson.map((meeting) => MeetingCalender.fromJson(meeting)).toList();

    return CalendarEventData(
      tasks: tasksList,
      meetings: meetingsList,
    );
  }
}

class TaskCalender {
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

  TaskCalender({
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

  factory TaskCalender.fromJson(Map<String, dynamic> json) {
    return TaskCalender(
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

class MeetingCalender {
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

  MeetingCalender({
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

  factory MeetingCalender.fromJson(Map<String, dynamic> json) {
    return MeetingCalender(
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
