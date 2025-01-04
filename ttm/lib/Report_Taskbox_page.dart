import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Comman_pages/Constant.dart';
import 'Comman_pages/Widgets_page.dart';
import 'Event_Detail_Pages/Event_Detail.dart';
import 'Report_taskbox_model.dart';


class TaskBoxPage extends StatefulWidget {
  final String taskStatus;
  final String selectedTimeFrame;

  TaskBoxPage({
    Key? key,
    required this.taskStatus,
    required this.selectedTimeFrame,
  }) : super(key: key);

  @override
  _TaskBoxPageState createState() => _TaskBoxPageState();
}

class _TaskBoxPageState extends State<TaskBoxPage> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode; // FocusNode to track focus state
  List<Task> _filteredTasks = [];
  List<Meeting> _filteredMeetings = [];
  String searchQuery = '';
  List<String> _suggestions = []; // Suggestions list

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode(); // Initialize the FocusNode
    _searchController.addListener(_filterTasks);

    // Listen for focus changes
    _searchFocusNode.addListener(() {
      setState(() {
        // Rebuild the widget when focus changes
      });
    });

    // Initialize _filteredTasks and _filteredMeetings with all available data
    final taskData = responseData[widget.taskStatus];
    if (taskData != null) {
      final selectedTaskData = taskData[widget.selectedTimeFrame];
      TaskModel taskModel = TaskModel.fromJson(selectedTaskData);

      _filteredTasks = taskModel.tasks;
      _filteredMeetings = taskModel.meetings;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  void _filterTasks() {
    searchQuery = _searchController.text.toLowerCase();

    final taskData = responseData[widget.taskStatus];
    if (taskData != null) {
      final selectedTaskData = taskData[widget.selectedTimeFrame];
      TaskModel taskModel = TaskModel.fromJson(selectedTaskData);

      // Filter tasks
      _filteredTasks = taskModel.tasks.where((task) {
        return task.title.toLowerCase().contains(searchQuery) ||
            task.description.toLowerCase().contains(searchQuery) ||
            task.assignedBy.toLowerCase().contains(searchQuery) ||
            task.location.toLowerCase().contains(searchQuery);
      }).toList();

      // Filter meetings
      _filteredMeetings = taskModel.meetings.where((meeting) {
        return meeting.title.toLowerCase().contains(searchQuery) ||
            meeting.description.toLowerCase().contains(searchQuery) ||
            meeting.assignedBy.toLowerCase().contains(searchQuery) ||
            meeting.location.toLowerCase().contains(searchQuery);
      }).toList();

      // Update suggestions
      _updateSuggestions(taskModel);
    }

    setState(() {}); // Update the UI
  }

  void _updateSuggestions(TaskModel taskModel) {
    _suggestions.clear();

    // Add unique suggestions from tasks
    for (var task in taskModel.tasks) {
      if (task.title.toLowerCase().contains(searchQuery) &&
          !_suggestions.contains(task.title)) {
        _suggestions.add(task.title);
      }
      if (task.location.toLowerCase().contains(searchQuery) &&
          !_suggestions.contains(task.location)) {
        _suggestions.add(task.location);
      }
      if (task.assignedBy.toLowerCase().contains(searchQuery) &&
          !_suggestions.contains(task.assignedBy)) {
        _suggestions.add(task.assignedBy);
      }
    }

    // Add unique suggestions from meetings
    for (var meeting in taskModel.meetings) {
      if (meeting.title.toLowerCase().contains(searchQuery) &&
          !_suggestions.contains(meeting.title)) {
        _suggestions.add(meeting.title);
      }
      if (meeting.location.toLowerCase().contains(searchQuery) &&
          !_suggestions.contains(meeting.location)) {
        _suggestions.add(meeting.location);
      }
      if (meeting.assignedBy.toLowerCase().contains(searchQuery) &&
          !_suggestions.contains(meeting.assignedBy)) {
        _suggestions.add(meeting.assignedBy);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskData = responseData[widget.taskStatus];

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
                  '${widget.taskStatus}',
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
            'No data available for ${widget.taskStatus}',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final selectedTaskData = taskData[widget.selectedTimeFrame];
    TaskModel taskModel = TaskModel.fromJson(selectedTaskData);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Adjust for the keyboard
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
                '${widget.taskStatus} ',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode, // Assign the FocusNode
                    cursorColor: AppColors.concolor,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: AppColors.concolor),
                      hintText: 'Search',
                      hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFE6E6E6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              // Show suggestions only when the search box is focused and has text
              if (_searchFocusNode.hasFocus && searchQuery.isNotEmpty && _suggestions.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _suggestions[index],
                          style: GoogleFonts.montserrat(fontSize: 14),
                        ),
                        onTap: () {
                          setState(() {
                            _searchController.text = _suggestions[index];
                            _suggestions.clear();
                            _filterTasks();
                          });
                        },
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Event: ",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.taskStatus} (${_filteredTasks.length + _filteredMeetings.length})",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: AppColors.concolor,
                      ),
                    ),
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ..._filteredTasks.map((task) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailPage(
                            id:task.id,
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
                            toTime: "", eventmode: '',
                          ),
                        ),
                      );
                    },
                    child: buildTaskDetailBox(
                      title: task.title,
                      description: task.description,
                      priority: task.priority,
                      date: task.date,
                      location: task.location,
                      event: task.event,
                      assignedBy: task.assignedBy,
                    ),
                  )),
                  Divider(),
                  ..._filteredMeetings.map((meeting) => GestureDetector(
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
                            toTime: meeting.toTime, id:meeting.id, eventmode: '',
                          ),
                        ),
                      );
                    },
                    child: buildMeetingDetailBox(
                      title: meeting.title,
                      description: meeting.description,
                      priority: meeting.priority,
                      status: meeting.status,
                      fromDate: meeting.fromDate,
                      toDate: meeting.toDate,
                      fromTime: meeting.fromTime,
                      toTime: meeting.toTime,
                      location: meeting.location,
                      event: meeting.event,
                      assignedby: meeting.assignedBy,
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*Widget _buildTaskDetailBoxforhome(
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
}*/