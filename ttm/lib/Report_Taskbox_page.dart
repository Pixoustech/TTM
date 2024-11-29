import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For date formatting

// Assuming AppColors is defined in your Constant.dart file
import 'Comman_pages/Constant.dart';
import 'Event_Detail_Pages/Event_Detail.dart';
import 'Report_taskbox_model.dart'; // Ensure this file contains the necessary model definitions

// Define your models (TaskModel, Task, Meeting) here as previously shown...

class TaskBoxPage extends StatelessWidget {
  final String taskStatus;
  final int taskCount;
  final String selectedTimeFrame;

  TaskBoxPage({Key? key, required this.taskStatus, required this.taskCount, required this.selectedTimeFrame}) : super(key: key);

  // Sample response data
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
            'event': 'Development',
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
            'status': 'Pending',
            'date': '2023-10-05T10:00:00',
            'location': 'Office',
            'event': 'Development',
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
    },
  };

  @override
  Widget build(BuildContext context) {
    // Check if the taskStatus exists in the responseData
    final taskData = responseData[taskStatus];

    // If taskData is null, return an empty container or a message
    if (taskData == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.concolor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  '$taskStatus',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backwhite,
                  ),
                ),
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: Center(
          child: Text(
            'No data available for $taskStatus',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    // If taskData is not null, parse it
    final selectedTaskData = taskData[selectedTimeFrame]; // Get data for the selected timeframe
    TaskModel taskModel = TaskModel.fromJson(selectedTaskData);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.concolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '$taskStatus ',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backwhite,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          ...taskModel.tasks.map((task) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(
                    title: task.title,
                    description: task.description,
                    priority: task.priority,
                    status: task.status,
                    date: task.date,
                    location: task.location,
                    pdfUrls: task.pdfUrls ?? [],
                    Event: task.event,
                    Assignedby: task.assignedBy,
                    Attachmentpdfurl: task.attachmentPdfUrls ?? [],
                    fromDate: task.date,
                    toDate: task.date,
                    fromTime: "",
                    toTime: "",
                  ),
                ),
              );
            },
            child: _buildTaskDetailBoxforhome(
              task.title,
              task.description,
              getPriorityColor(task.priority),
              task.priority,
              task.status,
              DateTime.parse(task.date.toString()),
              task.location,
              task.event,
              task.assignedBy,
            ),
          )),
          Divider(),
          ...taskModel.meetings.map((meeting) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(
                    title: meeting.title,
                    description: meeting.description,
                    priority: meeting.priority,
                    status: meeting.status,
                    date: meeting.fromDate, // Assuming you want to show the start date
                    location: meeting.location,
                    pdfUrls: [], // Assuming no PDFs for meetings
                    Event: meeting.event,
                    Assignedby: meeting.assignedBy,
                    Attachmentpdfurl: [], // Assuming no attachments for meetings
                    fromDate: meeting.fromDate,
                    toDate: meeting.toDate,
                    fromTime: meeting.fromTime,
                    toTime: meeting.toTime,
                  ),
                ),
              );
            },
            child : _buildTaskDetailBoxforhome(
              meeting.title,
              meeting.description,
              getPriorityColor(meeting.priority),
              meeting.priority,
              meeting.status,
              DateTime.parse(meeting.fromDate.toString()), // Assuming you want to show the start date
              meeting.location,
              meeting.event,
              meeting.assignedBy,
            ),
          )),
        ],
      ),
    );
  }
}

Widget _buildTaskDetailBoxforhome(
    String title,
    String description,
    Color color,
    String priority,
    String status,
    DateTime date,
    String location,
    String event,
    String assignedBy, // New parameter for the assigned by text
    ) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 120,
          decoration: BoxDecoration(
            color: getPriorityColor(priority ?? 'Medium'),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: 0),
        Expanded(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title, Priority, and Assigned By in one row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (priority != null)
                          Container(
                            margin: const EdgeInsets.only(left: 4.00),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: getPriorityColor(priority),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              priority,
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        if (assignedBy != null && assignedBy == "HQ")
                          Container(
                            margin: const EdgeInsets.only(left: 4.00),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.concolor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              assignedBy,
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            description,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8), // Add some space between the text and the icon
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.concolor,
                          size: 16,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: AppColors.concolor),
                        const SizedBox(width: 4),
                        Text(
                          '${date.toLocal()}'.split(' ')[0], // Format date as needed
                          style: GoogleFonts.montserrat(
                              fontSize: 10, color: Colors.black),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on,
                            size: 16, color: AppColors.concolor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: GoogleFonts.montserrat(
                                fontSize: 10, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 1,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "[$event]",
                    style: GoogleFonts.montserrat(
                        fontSize: 10, color: AppColors.concolor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
