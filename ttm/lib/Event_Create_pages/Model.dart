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
    };
  }
}

// models/meeting_model.dart

class MeetingModel {
  String id;
  String userId; // New field for user ID
  String eventName;
  String startDate; // Changed to String to match formatted date
  String endDate; // Changed to String to match formatted date
  String fromTime; // Kept as String
  String toTime; // Kept as String
  String priority;
  String venue;
  String description;
  String eventType;
  String eventMode; // Can be 'online' or 'offline'
  bool isActive;
  String savedDate; // Changed to String to match formatted date
  String? lat; // Latitude as a nullable string
  String? lon; // Longitude as a nullable string
  String? pincode; // Pincode as a nullable string
  String? state; // State as a nullable string
  String? city; // City as a nullable string

  MeetingModel({
    required this.id,
    required this.userId, // Include userId in the constructor
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
  });

  // Factory constructor to create a MeetingModel from JSON
  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '', // Map userId from JSON
      eventName: json['eventName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      fromTime: json['fromTime'] ?? '',
      eventType: json['eventType'] ?? '',
      venue: json['venue'] ?? '',
      toTime: json['toTime'] ?? '',
      priority: json['priority'] ?? '',
      description: json['description'] ?? '',
      eventMode: json['eventMode'] ?? 'offline',
      isActive: json['isActive'] ?? true,
      savedDate: json['savedDate'] ?? DateTime.now().toUtc().toIso8601String(),
      lat: json['lat'],
      lon: json['lon'],
      pincode: json['pincode'],
      state: json['state'],
      city: json['city'],
    );
  }

  // Method to convert a MeetingModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId, // Include userId in JSON
      "eventName": eventName,
      "startDate": startDate,
      "endDate": endDate,
      "fromTime": fromTime,
      "toTime": toTime,
      "priority": priority,
      "description": description,
      "eventMode": eventMode,
      "isActive": isActive,
      "savedDate": savedDate,
      "eventType": eventType,
      "venue": venue,
      "lat": lat,
      "lon": lon,
      "pincode": pincode,
      "state": state,
      "city": city,
    };
  }
}
