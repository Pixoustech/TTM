// lib/models/home_page_model.dart

class Task {
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime date;
  final String location;
  final List<String>? pdfUrls; // List of PDF URLs
  final String Event;
  final String Assignedby;
  final List<String>? Attachmentpdfurl;


  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.date,
    required this.location,
    this.pdfUrls, // Add pdfUrls to the constructor
    required this.Event,
    required this.Assignedby,
    this.Attachmentpdfurl,
  });
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
  final List<String>? pdfUrls; // List of PDF URLs
  final String Event;
  final String Assignedby;
  final List<String>? Attachmentpdfurl;

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
    this.pdfUrls, // Add pdfUrls to the constructor
    required this.Event,
    required this.Assignedby,
    this.Attachmentpdfurl,
  });
}

class HomePageData {
  final List<Task> tasks;
  final List<Meeting> meetings;

  HomePageData({required this.tasks, required this.meetings});
}

HomePageData getDefaultHomePageData() {
  return HomePageData(
    tasks: [
      Task(
        title: 'App DesignApp DesignApp DesignApp Design',
        description: 'hello',
        priority: 'Low',
        status: 'In Progress',
        date: DateTime.now(),
        location: 'Coimbatore',
        pdfUrls: [
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        ],
        Event: "Task",
        Assignedby: "Own",
        Attachmentpdfurl: [],
      ),
      Task(
        title: 'ApApp DesignApp DesignApp DesignApp DesignApp Designp',
        description: 'The current website design needs a refresh to improve user experience and enhance visual appeal.......',
        priority: 'Medium',
        status: 'Not Started',
        date: DateTime.now().add(Duration(days: -2)),
        location: 'Coimbatore',
        pdfUrls: [
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        ], // List of PDF URLs
          Event: "Task",
          Assignedby: "HQ",
        Attachmentpdfurl: [],
      ),
      Task(
        title: 'Testing',
        description: 'The current website design needs a refresh to improve user experience and enhance visual appeal',
        priority: 'Low',
        status: 'Overdue',
        date: DateTime.now().add(Duration(days: -5)),
        location: 'Coimbatore',
        pdfUrls: [
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        ], // List of PDF URLs
          Event: "Task",
          Assignedby: "Own",
        Attachmentpdfurl: ['https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'],
      ),
    ],
    meetings: [
      Meeting(
        title: 'App DesignApp DesignApp DesignApp DesignApp Design',
        description: 'Discuss the new design for the application.',
        priority: 'Medium',
        status: 'In Progress',
        fromDate: DateTime(2024, 10, 25),
        toDate: DateTime(2024, 10, 19),
        fromTime: '10:00 AM',
        toTime: '12:00 PM',
        location: 'Coimbatore',
        pdfUrls: [
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        ], // List of PDF URLs
          Event: "Meeting",
          Assignedby: "Own"
      ),
      Meeting(
        title: 'Team Sync',
        description: 'Weekly team sync to discuss project progress.',
        priority: 'High',
        status: 'Not Started',
        fromDate: DateTime(2024, 10, 26),
        toDate: DateTime(2024, 10, 02),
        fromTime: '2:00 PM',
        toTime: '3:00 PM',
        location: 'Coimbatore',
        pdfUrls: [
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        ], // List of PDF URLs
          Event: "Meeting",
          Assignedby: "Own"
      ),
      Meeting(
        title: 'App Design Meeting App DesignApp DesignApp DesignApp DesignApp DesignApp Design',
        description: 'Discuss the new design for the application.',
        priority: 'Low',
        status: 'In Progress',
        fromDate: DateTime(2024, 10, 25),
        toDate: DateTime(2024, 10 , 12),
        fromTime: '10:00 AM',
        toTime: '12:00 PM',
        location: 'Coimbatore',
        pdfUrls: [
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        ], // List of PDF URLs
          Event: "Meeting",
          Assignedby: "HQ"
      ),
    ],
  );
}
