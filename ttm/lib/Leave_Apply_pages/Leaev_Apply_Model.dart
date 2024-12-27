// leave_application_model.dart
class LeaveApplication {
  String id;
  String userId;
  String groupId;
  String leaveTypeId;
  DateTime date;
  int noOfDays;
  String reason;
  String statusId;
  String nextApprovalRoleId;
  bool isActive;
  String savedBy;
  String savedByUserName;
  DateTime savedDate;

  LeaveApplication({
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
    required this.savedBy,
    required this.savedByUserName,
    required this.savedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'groupId': groupId,
      'leaveTypeId': leaveTypeId,
      'date': date.toIso8601String(),
      'noofDays': noOfDays,
      'reason': reason,
      'statusId': statusId,
      'nextApprovalRoleId': nextApprovalRoleId,
      'isActive': isActive,
      'savedBy': savedBy,
      'savedByUser Name': savedByUserName,
      'savedDate': savedDate.toIso8601String(),
    };
  }

  factory LeaveApplication.fromJson(Map<String, dynamic> json) {
    return LeaveApplication(
      id: json['id'],
      userId: json['userId'],
      groupId: json['groupId'],
      leaveTypeId: json['leaveTypeId'],
      date: DateTime.parse(json['date']),
      noOfDays: json['noofDays'],
      reason: json['reason'],
      statusId: json['statusId'],
      nextApprovalRoleId: json['nextApprovalRoleId'],
      isActive: json['isActive'],
      savedBy: json['savedBy'],
      savedByUserName: json['savedByUser Name'],
      savedDate: DateTime.parse(json['savedDate']),
    );
  }
}