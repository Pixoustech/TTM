// calendar_model.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// leave_model.dart
class Leave {
  final String id;
  final String userId;
  final String groupId;
  final String leaveTypeId;
  final DateTime date;
  final int noOfDays;
  final String reason;
  final String statusId;
  final String nextApprovalRoleId;
  final bool isActive;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String userGroup;
  final String branchId;
  final String divisionId;
  final String districtId;
  final String groupIdValue;
  final String leaveIdValue;
  final String statusName;
  final String statusCode;
  final String createdBy;
  final String createdByUserName;
  final DateTime createdDate;

  Leave({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.leaveTypeId,
    required this.date,
    required this.noOfDays,
    required this.reason,
    required this.statusId,
    required this.nextApprovalRoleId,
    required this.isActive,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.userGroup,
    required this.branchId,
    required this.divisionId,
    required this.districtId,
    required this.groupIdValue,
    required this.leaveIdValue,
    required this.statusName,
    required this.statusCode,
    required this.createdBy,
    required this.createdByUserName,
    required this.createdDate,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'],
      userId: json['userId'],
      groupId: json['groupId'],
      leaveTypeId: json['leaveTypeId'],
      date: _parseDate(json['date']),
      noOfDays: json['noofDays'],
      reason: json['reason'],
      statusId: json['statusId'],
      nextApprovalRoleId: json['nextApprovalRoleId'],
      isActive: json['isActive'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      mobile: json['mobile'],
      userGroup: json['userGroup'],
      branchId: json['branchId'],
      divisionId: json['divisionId'],
      districtId: json['districtId'],
      groupIdValue: json['groupIdValue'],
      leaveIdValue: json['leaveIdValue'],
      statusName: json['statusName'],
      statusCode: json['statusCode'],
      createdBy: json['createdBy'],
      createdByUserName: json['createdByUserName'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
  // Method to parse date strings
  static DateTime _parseDate(String dateString) {
    try {
      // Attempt to parse the date using the expected format
      return DateFormat("MM/dd/yyyy HH:mm:ss").parse(dateString);
    } catch (e) {
      // If parsing fails, print the error and return the current date or handle as needed
      print('Error parsing date: $e');
      return DateTime.now(); // Fallback to current date or handle as needed
    }
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
