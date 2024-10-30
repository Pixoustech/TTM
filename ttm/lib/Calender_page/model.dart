class LeaveStatus {
  final DateTime fromDate;
  final DateTime toDate;
  final String status;
  final String title;
  final String description;


  LeaveStatus({required this.fromDate, required this.toDate, required this.status,required this.title,required this.description});
}
class Event {
  final String title;
  final String description;
  final DateTime date;

  Event({
    required this.title,
    required this.description,
    required this.date,
  });
}



