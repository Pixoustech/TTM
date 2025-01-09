// models/task_model.dart
// models/task_model.dart

class TaskModel {
  String id;
  String userId; // New field for user ID
  String eventName;
  String dueDate; // Due date as a string to match formatted date
  String location;
  String priority;
  String description;
  bool isActive;
  bool isSelfEvent;
  String savedDate; // Saved date as a string to match formatted date
  String eventType;
  String? lat; // Latitude as a nullable string
  String? lon; // Longitude as a nullable string
  String? pincode; // Pincode as a nullable string
  String? state; // State as a nullable string
  String? city; // City as a nullable string
  List<String> distributionIds; // New field for distribution IDs
  List<String> userIds; // New field for user IDs
  List<String> days; // New field for days
  String occurrenceType; // New field for occurrence type

  TaskModel({
    required this.id,
    required this.userId, // Include userId in the constructor
    required this.eventName,
    required this.dueDate,
    required this.location,
    required this.priority,
    required this.description,
    required this.isActive,
    required this.isSelfEvent,
    required this.savedDate,
    required this.eventType,
    this.lat,
    this.lon,
    this.pincode,
    this.state,
    this.city,
    required this.distributionIds, // Include distributionIds in the constructor
    required this.userIds, // Include userIds in the constructor
    required this.days, // Include days in the constructor
    required this.occurrenceType,
  });

  // Factory constructor to create a TaskModel instance from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '', // Map userId from JSON
      eventName: json['eventName'] ?? '',
      dueDate: json['dueDate'] ?? '',
      location: json['location'] ?? '',
      priority: json['priority'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? true,
      isSelfEvent: json['isSelfEvent'] ?? true,
      savedDate: json['savedDate'] ?? DateTime.now().toUtc().toIso8601String(),
      eventType: json['eventType'] ?? '',
      lat: json['lat'],
      lon: json['lon'],
      pincode: json['pincode'],
      state: json['state'],
      city: json['city'],
      distributionIds: List<String>.from(json['distributionIds'] ?? []), // Map distributionIds from JSON
      userIds: List<String>.from(json['userIds'] ?? []), // Map userIds from JSON
      days: List<String>.from(json['days'] ?? []), // Map days from JSON
      occurrenceType: json['occurenceType'] ?? 'Once', // Map occurrenceType from JSON
    );
  }

  // Method to convert a TaskModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId, // Include userId in JSON
      "eventName": eventName,
      "dueDate": dueDate,
      "location": location,
      "priority": priority,
      "description": description,
      "isActive": isActive,
      "isSelfEvent": isSelfEvent,
      "savedDate": savedDate,
      "eventType": eventType,
      "lat": lat,
      "lon": lon,
      "pincode": pincode,
      "state": state,
      "city": city,
      "distributionIds": distributionIds, // Include distributionIds in JSON
      "userIds": userIds, // Include userIds in JSON
      "days": days, // Include days in JSON
    "occurenceType":occurrenceType,
    };
  }
}
// models/meeting_model.dart
// models/meeting_model.dart
class MeetingModel {
  String id;
  String userId;
  String eventName;
  String startDate;
  String endDate;
  String fromTime;  // Changed to DateTime for better handling
  String toTime;
  String priority;
  String venue;
  String description;
  String eventType;
  String eventMode;
  bool isSelfEvent;
  bool isActive;
  String savedDate;
  String? lat;
  String? lon;
  String? pincode;
  String? state;
  String? city;
  List<String> distributionIds; // New field for distribution IDs
  List<String> userIds; // New field for user IDs
  List<String> days; // New field for days
  String occurrenceType; // New field for occurrence type

  MeetingModel({
    required this.isSelfEvent,
    required this.id,
    required this.userId,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.fromTime,
    required this.toTime,
    required this.priority,
    required this.venue,
    required this.description,
    required this.eventMode,
    required this.isActive,
    required this.savedDate,
    required this.eventType,
    this.lat,
    this.lon,
    this.pincode,
    this.state,
    this.city,
    required this.distributionIds, // Include distributionIds in the constructor
    required this.userIds, // Include userIds in the constructor
    required this.days, // Include days in the constructor
    required this.occurrenceType,
  });

  // Factory constructor to create a MeetingModel from JSON
  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      eventName: json['eventName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      fromTime: json['fromTime'] ?? '',
      toTime: json['toTime'] ?? '',
      priority: json['priority'] ?? '',
      description: json['description'] ?? '',
      eventMode: json['eventMode'] ?? 'offline',
      isActive: json['isActive'] ?? true,
      isSelfEvent: json['isSelfEvent'] ?? true,
      savedDate: json['savedDate'] ?? DateTime.now().toUtc().toIso8601String(),
      eventType: json['eventType'] ?? '',
      venue: json['venue'] ?? '',
      lat: json['lat'],
      lon: json['lon'],
      pincode: json['pincode'],
      state: json['state'],
      city: json['city'],
      distributionIds: List<String>.from(json['distributionIds'] ?? []), // Map distributionIds from JSON
      userIds: List<String>.from(json['userIds'] ?? []), // Map userIds from JSON
      days: List<String>.from(json['days'] ?? []), // Map days from JSON
      occurrenceType: json['occurenceType'] ?? 'Once', // Map occurrenceType from JSON
    );
  }

  // Method to convert a MeetingModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "eventName": eventName,
      "startDate": startDate,
      "endDate": endDate,
      "fromTime": fromTime,
      "toTime": toTime,
      "priority": priority,
      "description": description,
      "eventMode": eventMode,
      "isActive": isActive,
      "isSelfEvent": isSelfEvent,
      "savedDate": savedDate,
      "eventType": eventType,
      "venue": venue,
      "lat": lat,
      "lon": lon,
      "pincode": pincode,
      "state": state,
      "city": city,
      "distributionIds": distributionIds, // Include distributionIds in JSON
      "userIds": userIds, // Include userIds in JSON
      "days": days, // Include days in JSON
      "occurenceType":occurrenceType,
    };
  }
}

