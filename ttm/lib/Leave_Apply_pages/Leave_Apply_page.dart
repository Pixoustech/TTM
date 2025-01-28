import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttm/Comman_pages/Constant.dart';
import 'package:intl/intl.dart';

import 'Leaev_Apply_Model.dart';
import 'Leave_Apply_Service.dart'; // Import this for date formatting

class LeaveApplyPage extends StatefulWidget {
  @override
  _LeaveApplyPageState createState() => _LeaveApplyPageState();
}

class _LeaveApplyPageState extends State<LeaveApplyPage> {
  final TextEditingController _leaveTypeController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _noOfDaysController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final LeaveApplicationService _leaveApplicationService = LeaveApplicationService();
  final LeaveApplicationServiceDropdown _leaveApplicationServiceDropdown = LeaveApplicationServiceDropdown();
  List<LeaveTypeModel> _leaveTypes = []; // List to store fetched leave types
  LeaveTypeModel? _selectedLeaveType; // To store selected leave type

  @override
  void initState() {
    super.initState();
    _fetchLeaveTypes(); // Fetch leave types when the page is initialized
  }

  Future<void> _fetchLeaveTypes() async {
    try {
      List<LeaveTypeModel> leaveTypes = await _leaveApplicationServiceDropdown.fetchLeaveTypes();
      setState(() {
        _leaveTypes = leaveTypes; // Update the leave types list
      });
    } catch (e) {
      // Handle error if fetching leave types fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch leave types: $e')),
      );
    }
  }
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Leave Apply Page',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.concolor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leave Type
              // Leave Type
              Text('Leave Type', style: GoogleFonts.montserrat(fontSize: 16)),
              _leaveTypes.isEmpty
                  ? CircularProgressIndicator() // Show loading indicator if leave types are not fetched yet
                  : DropdownButton<LeaveTypeModel>(
                hint: Text('Select Leave Type'),
                value: _selectedLeaveType,
                onChanged: (LeaveTypeModel? newValue) {
                  setState(() {
                    _selectedLeaveType = newValue;
                  });
                },
                isExpanded: true,
                items: _leaveTypes.map((LeaveTypeModel leaveType) {
                  return DropdownMenuItem<LeaveTypeModel>(
                    value: leaveType,
                    child: Text(leaveType.leaveTypeName ?? ''),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // From and To Date
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From Date', style: GoogleFonts.montserrat(fontSize: 16)),
                        TextField(
                          controller: _fromDateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Select from date',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.concolor), // Focused border color
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context, _fromDateController),
                            ),
                          ),
                          cursorColor: AppColors.concolor, // Cursor color
                          readOnly: true, // Make it read-only
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('To Date', style: GoogleFonts.montserrat(fontSize: 16)),
                        TextField(
                          controller: _toDateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Select to date',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.concolor), // Focused border color
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context, _toDateController),
                            ),
                          ),
                          cursorColor: AppColors.concolor, // Cursor color
                          readOnly: true, // Make it read-only
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // No. of Days
              Text('No. of Days', style: GoogleFonts.montserrat(fontSize: 16)),
              TextField(
                controller: _noOfDaysController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter number of days',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.concolor), // Focused border color
                  ),
                ),
                cursorColor: AppColors.concolor, // Cursor color
              ),
              SizedBox(height: 16),

              // Reason
              Text('Reason', style: GoogleFonts.montserrat(fontSize: 16)),
              TextField(
                controller: _reasonController,
                maxLines: 5, // Allows for multiple lines
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter reason for leave',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.concolor), // Focused border color
                  ),
                ),
                cursorColor: AppColors.concolor, // Cursor color
              ),
              SizedBox(height: 16),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50, // Set height for the buttons
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle cancel action
                          Navigator.pop(context); // Close the page
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.concolor, // Text color
                          backgroundColor: Colors.white, // Background color
                          side: BorderSide(color: AppColors.concolor), // Border color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // Box shape
                          ),
                        ),
                        child: Text('Cancel', style: GoogleFonts.montserrat()),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 50, // Set height for the buttons
                      child: ElevatedButton(
                        onPressed: _applyLeave,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, // Text color
                          backgroundColor: AppColors.concolor, // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // Box shape
                          ),
                        ),
                        child: Text('Apply', style: GoogleFonts.montserrat()),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyLeave() async {
    try {
      LeaveApplication leaveApplication = LeaveApplication(
        id: '', // Generate or fetch the ID as needed
        userId: '', // Replace with actual user ID
        groupId: '', // Replace with actual group ID
        leaveTypeId: '', // Replace with actual leave type ID
        date: DateTime.parse(_fromDateController.text), // Use the selected from date
        noOfDays: int.parse(_noOfDaysController.text), // Parse number of days
        reason: _reasonController.text,
        statusId: 'your_status_id', // Replace with actual status ID
        nextApprovalRoleId: 'your_next_approval_role_id', // Replace with actual approval role ID
        isActive: true,
        savedBy: 'your_savedBy', // Replace with actual saved by information
        savedByUserName: 'your_saved_by_username', // Replace with actual saved by username
        savedDate: DateTime.now(), // Use the current date for saved date
      );

      final response = await _leaveApplicationService.applyLeave(leaveApplication);
      if (response['status'] == 'SUCCESS') {
        // Handle success, e.g., show a success message or navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Leave applied successfully!')),
        );
        Navigator.pop(context); // Close the page
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      }
    } catch (e) {
      // Handle any exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to apply leave: $e')),
      );
    }
  }
}