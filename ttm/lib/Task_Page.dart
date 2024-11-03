import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Constant.dart';
import 'Navigation_page.dart';
import 'package:file_picker/file_picker.dart';

class Createevent extends StatefulWidget {
  const Createevent({super.key});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<Createevent> {
  String _currentView = 'event';
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _meetingNameController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _venueOrLinkController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController(); // New controller for venue or link
  // Variable to hold the selected file name
  String? _selectedFileName;
  String? _selectedMode; // New variable to track selected mode (online/offline)

  @override
  void initState() {
    super.initState();
    _selectedMode = 'offline'; // Set default mode to offline
    _venueOrLinkController.text = 'Venue'; // Set default text for venue
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.concolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.backwhite),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Navigation()),
            );
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Create Event',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _clickableTitle('Event'),
                _clickableTitle('Meeting'),
              ],
            ),
            const SizedBox(height: 8),
            _buildIndicators(),
            const SizedBox(height: 16),
            _buildInputFields(),
            const SizedBox(height: 16),
            _buildPrioritySelector(),
            const SizedBox(height: 16),
            _buildDescriptionField(), // Updated to include file picker
          ],
        ),
      ),
    );
  }

  Widget _clickableTitle(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentView = title.toLowerCase();
        });
      },
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _currentView.toLowerCase() == title.toLowerCase()
              ? AppColors.concolor
              : Colors.black,
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 4,
        width: 320,
        decoration: BoxDecoration(
          color: Color(0xFFD28F91),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: _currentView == 'event' ? 0 : 160,
              child: Container(
                height: 4,
                width: 160,
                decoration: BoxDecoration(
                  color: AppColors.concolor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_currentView == 'event') ...[
          _buildTextField('Task Name', _taskNameController),
          const SizedBox(height: 12),
          _buildTextFieldWithCalendar('Due Date', _dueDateController),
          const SizedBox(height: 12),
          _buildTextField('Location', _locationController),
        ] else if (_currentView == 'meeting') ...[
          _buildTextField('Meeting Name', _meetingNameController),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextFieldWithCalendar('From Date', _fromDateController),
              ),
              const SizedBox(width: 8), // Space between the two fields
              Expanded(
                child: _buildTextField('From Time', _fromTimeController),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextFieldWithCalendar('To Date', _toDateController),
              ),
              const SizedBox(width: 8), // Space between the two fields
              Expanded(
                child: _buildTextField('To Time', _toTimeController),
              ),
            ],
          ),// Space between the row and the Location field
          _buildTextField('Location', _locationController), // Show Location text field below the row
        ],
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithCalendar(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _selectDueDate,
              ),
            ),
            readOnly: true,
            onTap: _selectDueDate,
          ),
        ],
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _dueDateController.text =
      "${picked.toLocal()}".split(' ')[0];
    }
  }

  Widget _buildPrioritySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Priority',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildPriorityBox('High', Colors.red)),
              const SizedBox(width: 8),
              Expanded(child: _buildPriorityBox('Medium', Colors.orange)),
              const SizedBox(width: 8),
              Expanded(child: _buildPriorityBox('Low', Colors.green)),
            ],
          ),
          const SizedBox(height: 16), // Add space between priority and buttons
          if (_currentView == 'meeting') ...[
            _buildOnlineOfflineButtons(), // Show buttons only for meetings
          ],
        ],
      ),
    );
  }

  Widget _buildOnlineOfflineButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedMode = 'offline'; // Update selected mode to offline
                    _venueOrLinkController.text = 'Venue'; // Set default text for venue
                  });
                },
                child: Text('Offline'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _selectedMode == 'offline'
                      ? Colors.white
                      : AppColors.concolor,
                  backgroundColor: _selectedMode == 'offline'
                      ? AppColors.concolor
                      : Colors.white,
                  side: BorderSide(color: AppColors.concolor, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12), // Padding
                ),
              ),
            ),
            const SizedBox(width: 8), // Space between buttons
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedMode = 'online'; // Update selected mode to online
                    _venueOrLinkController.text = 'Link'; // Set default text for link
                  });
                },
                child: Text('Online'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _selectedMode == 'online'
                      ? Colors.white
                      : AppColors.concolor,
                  backgroundColor: _selectedMode == 'online'
                      ? AppColors.concolor
                      : Colors.white,
                  side: BorderSide(color: AppColors.concolor, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12), // Padding
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Space between buttons and text field
        TextField(
          controller: _venueOrLinkController,
          readOnly: true,
          cursorColor: AppColors.concolor,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45, width: 1.0), // Set the border color
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45, width: 2.0), // Set the focused border color
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          ),
        ),
        const SizedBox(height: 16), // Space between venue/link and assigned to
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assigned to',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _assignedToController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityBox(String label, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle priority selection
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45), // Border color
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 12), // Padding inside the box
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            CircleAvatar(
              radius: 6, // Dot size
              backgroundColor: color,
            ),
            const SizedBox(width: 8), // Space between dot and label
            Text(
              label,
              style: GoogleFonts.montserrat(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Task File',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          DottedBorder(
            color: AppColors.concolor,
            strokeWidth: 1,
            dashPattern: [6, 3],
            borderType: BorderType.RRect,
            radius: Radius.circular(8),
            child: InkWell(
              onTap: _pickFile,
              child: Container(
                height: 100, // Adjusted height for better visibility
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Circular button with icon and shadow
                    GestureDetector(
                      onTap: _pickFile, // Allow tapping the button to pick a file
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.backwhite, // Background color of the button
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 2, // Spread radius
                              blurRadius: 5, // Blur radius
                              offset: Offset(0, 3), // Offset for the shadow
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 20, // Radius of the circular button
                          backgroundColor: AppColors.backwhite, // Background color of the button
                          child: Icon(
                            Icons.upload_file_rounded, // Upload icon
                            size: 24, // Size of the icon
                            color: AppColors.concolor, // Icon color
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Space between button and text
                    Text(
                      _selectedFileName ?? 'Drag and Drop files here or choose file',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16), // Space before buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  // Handle cancel action
                  setState(() {
                    _selectedFileName = null; // Clear the selected file name
                  });
                },
                child: Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.concolor, backgroundColor: Colors.white, // Button background color
                  side: BorderSide(color: AppColors.concolor, width: 1), // Border color and width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
                  minimumSize: Size(120, 50), // Minimum width and height
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  // Handle create action
                  // Add your create event logic here
                  // Example: save the event, navigate to another page, etc.
                },
                child: Text('Create'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: AppColors.concolor, // Button background color
                  side: BorderSide(color: Colors.white, width: 1), // Border color and width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
                  minimumSize: Size(120, 50), // Minimum width and height
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    // Request storage permission
    var status = await Permission.storage.request();

    if (status.isGranted) {
      // Permission granted, proceed to pick a file
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _selectedFileName = result.files.single.name;
        });
      }
    } else {
      // Handle permission denied scenario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }



}