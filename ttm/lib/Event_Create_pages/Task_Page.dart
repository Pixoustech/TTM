import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Comman_pages/Constant.dart';
import '../Comman_pages/Navigation_page.dart';
import 'package:file_picker/file_picker.dart';

import 'Model.dart';
import 'Service.dart';


class Createevent extends StatefulWidget {
  const Createevent({super.key});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<Createevent> {
  String _currentView = 'task';
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
  final TextEditingController _toTimeController = TextEditingController();


  String? selectedLatitude;
  String? selectedLongitude;
  String? selectedPincode;
  String? selectedState;
  String? selectedCity;

  String? _selectedFileName;
  String? _selectedMode;
  String? _selectedPriority;
  List<String> _addressSuggestions = [];
  bool _isLoadingSuggestions = false; // To show loading indicator
  bool _hasInteracted = false; // Track if the user has interacted with the form
  @override
  void initState() {
    super.initState();
    _selectedMode = 'offline';
    _venueOrLinkController.text = 'Venue';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check if any fields are filled
        if (_hasUnsavedChanges()) {
          // Show confirmation dialog
          return await _showDataLossDialog() ??
              false; // Return the user's choice
        }
        return true; // Allow pop if no fields are filled
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                  _clickableTitle('Task'),
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
              _buildDescriptionField(),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasUnsavedChanges() {
    return _taskNameController.text.isNotEmpty ||
        _meetingNameController.text.isNotEmpty ||
        _dueDateController.text.isNotEmpty ||
        _locationController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _fromDateController.text.isNotEmpty ||
        _fromTimeController.text.isNotEmpty ||
        _toDateController.text.isNotEmpty ||
        _toTimeController.text.isNotEmpty ||
        _venueOrLinkController.text.isNotEmpty ||
        _assignedToController.text.isNotEmpty;
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
              left: _currentView == 'task' ? 0 : 160,
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

  Widget _clickableTitle(String title) {
    return GestureDetector(
      onTap: () {
        // Check if the user has interacted with the form
        if (_hasUnsavedChanges() && _hasInteracted) {
          // Show the dialog only if there are unsaved changes and the user has interacted
          _showDataLossDialog().then((shouldLeave) {
            if (shouldLeave == true) {
              setState(() {
                _currentView = title.toLowerCase();
                _resetFields();
              });
            }
          });
        } else {
          // If there are no unsaved changes or it's the first interaction, switch the view directly
          setState(() {
            _currentView = title.toLowerCase();
            _resetFields();
            _hasInteracted = true; // Mark that the user has interacted
          });
        }
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

  Future<bool?> _showDataLossDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text('You have unsaved changes. Do you want to continue?'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // User chooses not to leave
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _resetFields(); // Reset fields if user chooses to leave
                Navigator.of(context).pop(true); // User chooses to leave
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _resetFields() {
    _taskNameController.clear();
    _meetingNameController.clear();
    _dueDateController.clear();
    _locationController.clear();
    _descriptionController.clear();
    _fromDateController.clear();
    _fromTimeController.clear();
    _toDateController.clear();
    _toTimeController.clear();
    _venueOrLinkController.clear();
    _assignedToController.clear();
    _selectedPriority = null;
    _addressSuggestions.clear();
  }

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_currentView == 'task') ...[
          _buildSimpleTextField('Task Name', _taskNameController),
          const SizedBox(height: 12),
          _buildTextFieldWithCalendar('Due Date', _dueDateController),
          const SizedBox(height: 12),
          _buildTextField('Location', _locationController, true),
        ] else if (_currentView == 'meeting') ...[
          _buildSimpleTextField('Meeting Name', _meetingNameController),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextFieldWithCalendar('From Date', _fromDateController, isFromDate: true),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextFieldWithTime('From Time', _fromTimeController),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextFieldWithCalendar('To Date', _toDateController, isToDate: true),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextFieldWithTime('To Time', _toTimeController),
              ),
            ],
          ),
        ],
      ],
    );
  }
  Widget _buildSimpleTextField(String label, TextEditingController controller) {
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
            style: GoogleFonts.montserrat(fontSize: 12),
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 4.0, horizontal: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      bool hasIcon) {
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
            style: GoogleFonts.montserrat(fontSize: 12),
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              suffixIcon: hasIcon
                  ? IconButton(
                icon: const Icon(Icons.location_on),
                  onPressed: () async {
                    var status = await Permission.location.request();
                    if (status.isGranted) {
                      final LatLng? selectedLocation = await EventUtils.selectLocation(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Location permission denied')),
                      );
                    }
                  }
              )
                  : null,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                _fetchAddressSuggestions(value);
              } else {
                setState(() {
                  _addressSuggestions.clear();
                });
              }
            },
          ),
          if (_isLoadingSuggestions)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CircularProgressIndicator(),
            ),
          if (_addressSuggestions.isNotEmpty)
            Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _addressSuggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_addressSuggestions[index]),
                    onTap: () {
                      controller.text = _addressSuggestions[index];
                      setState(() {
                        _addressSuggestions.clear();
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithCalendar(String label, TextEditingController controller, {bool isFromDate = false, bool isToDate = false}) {
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
            style: GoogleFonts.montserrat(fontSize: 14),
            cursorColor: AppColors.concolor,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.concolor, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDateAndTime(controller, isFromDate ? _fromTimeController : _toTimeController);
                },
              ),
            ),
            readOnly: true,
            onTap: () {
              _selectDateAndTime(controller, isFromDate ? _fromTimeController : _toTimeController);
            },
          ),
        ],
      ),
    );
  }
  Widget _buildTextFieldWithTime(String label,
      TextEditingController controller) {
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
            style: GoogleFonts.montserrat(fontSize: 14),
            cursorColor: AppColors.concolor,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.concolor, width: 2.0),
              ),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              suffixIcon: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () {
                  _selectTime(controller);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDueDate(TextEditingController dateController, TextEditingController timeController) async {
    // Select the date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Set the date in the controller
      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);

      // Automatically open the time picker after selecting the date
      await _selectTime(timeController);
    }
  }
  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      // Format the time to 'HH:mm'
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute));
      controller.text = formattedTime;
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
          const SizedBox(height: 16),
          if (_currentView == 'meeting') ...[
            _buildOnlineOfflineButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildPriorityBox(String label, Color color) {
    bool isSelected = _selectedPriority == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.black : Colors.black45),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 6,
              backgroundColor: color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.black,
              ),
            ),
          ],
        ),
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
                    _selectedMode = 'offline';
                    _venueOrLinkController.text = ''; // Clear the text field
                    _addressSuggestions
                        .clear(); // Clear suggestions when switching modes
                  });
                },
                child: Text(
                  'Offline',
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
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
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedMode = 'online';
                    _venueOrLinkController.text = ''; // Clear the text field
                    _addressSuggestions
                        .clear(); // Clear suggestions when switching modes
                  });
                },
                child: Text(
                  'Online',
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
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
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _venueOrLinkController,
          cursorColor: AppColors.concolor,
          decoration: InputDecoration(
            hintText: _selectedMode == 'online' ? 'Link' : 'Venue',
            // Set hint text based on mode
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.concolor, width: 2.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 4.0, horizontal: 12.0),
            suffixIcon: _selectedMode ==
                'online' // Show paste icon only in online mode
                ? IconButton(
              icon: const Icon(Icons.paste), // Use paste icon
              onPressed: () async {
                // Get the clipboard data
                final data = await Clipboard.getData(Clipboard.kTextPlain);
                if (data != null && data.text != null) {
                  // Paste the text into the text field
                  _venueOrLinkController.text = data.text!;
                }
              },
            )
                : _selectedMode ==
                'offline' // Show location icon only in offline mode
                ? IconButton(
              icon: const Icon(Icons.location_on),
              onPressed: () async {
                var status = await Permission.location.request();
                if (status.isGranted) {
                  final LatLng? selectedLocation = await EventUtils
                      .selectLocation(context);
                  if (selectedLocation != null) {
                    _venueOrLinkController.text =
                    '${selectedLocation.latitude}, ${selectedLocation
                        .longitude}';
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Location permission denied')),
                  );
                }
              },
            )
                : null, // No icon in other cases
          ),
          onChanged: (value) {
            if (_selectedMode == 'offline' && value.isNotEmpty) {
              _fetchAddressSuggestions(
                  value); // Fetch suggestions only in offline mode
            } else if (_selectedMode == 'online') {
              setState(() {
                _addressSuggestions.clear(); // Clear suggestions in online mode
              });
            }
          },
        ),
        if (_isLoadingSuggestions)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CircularProgressIndicator(),
          ),
        if (_addressSuggestions.isNotEmpty)
          Container(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _addressSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_addressSuggestions[index]),
                  onTap: () {
                    _venueOrLinkController.text = _addressSuggestions[index];
                    setState(() {
                      _addressSuggestions.clear();
                    });
                  },
                );
              },
            ),
          ),
      ],
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
              contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
                height: 100,
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickFile,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.backwhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.backwhite,
                          child: Icon(
                            Icons.upload_file_rounded,
                            size: 24,
                            color: AppColors.concolor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _selectedFileName ??
                          'Drag and Drop files here or choose file',
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedFileName = null;
                  });
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.concolor,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: AppColors.concolor, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  minimumSize: Size(120, 50),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  sendDataToApi();
                },
                child: Text(
                  'Create',
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.concolor,
                  side: BorderSide(color: Colors.white, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  minimumSize: Size(120, 50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _selectedFileName = result.files.single.name;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }


  Future<void> sendDataToApi() async {
    try {
      // Check if the location is provided
      if (_locationController.text.isNotEmpty || _venueOrLinkController.text.isNotEmpty) {
if(_locationController.text.isNotEmpty)
        await _fetchCoordinatesFromAddress(_locationController.text );
else{
  await _fetchCoordinatesFromAddress(_venueOrLinkController.text );
}
      } else {
        print('Please provide a valid address');
        return; // Exit the function if no address is provided
      }

      EventService eventService = EventService(); // Initialize the event service

      if (_currentView == 'task') {
        // Create the TaskModel instance
        TaskModel task = TaskModel(
          id: '',
          userId: AppConstants.userId ?? '',
          eventName: _taskNameController.text,
          dueDate: _dueDateController.text,
          location: _locationController.text,
          priority: _selectedPriority ?? 'Medium',
          description: _descriptionController.text,
          eventType: _currentView,
          isActive: true,
          isSelfEvent:true,
          savedDate: DateTime.now().toUtc().toIso8601String(), // Current date and time in UTC
          lat: selectedLatitude, // Add selected latitude
          lon: selectedLongitude, // Add selected longitude
          pincode: selectedPincode, // Add selected pincode
          state: selectedState, // Add selected state
          city: selectedCity, // Add selected city
        );

        // Call the event service to create the task
        bool success = await eventService.createTask(task);

        if (success) {
          print('Task created successfully');
        } else {
          print('Failed to create task');
        }
      } else if (_currentView == 'meeting') {
        // Create the MeetingModel instance
        MeetingModel meeting = MeetingModel(
          id: '',
          userId: AppConstants.userId ?? '',
          eventName: _meetingNameController.text,
          eventType:_currentView,
          startDate: _fromDateController.text, // Use formatted date
          endDate: _toDateController.text, // Use formatted date
          fromTime: _fromTimeController.text,
          toTime: _toTimeController.text,
          priority: _selectedPriority ?? 'Medium',
          description: _descriptionController.text,
          eventMode: _selectedMode ?? 'offline',
          isActive: true,
          venue: _venueOrLinkController.text,
          savedDate: DateTime.now().toUtc().toIso8601String(), // Current date and time in UTC
          lat: selectedLatitude, // Add selected latitude
          lon: selectedLongitude, // Add selected longitude
          pincode: selectedPincode, // Add selected pincode
          state: selectedState, // Add selected state
          city: selectedCity, // Add selected city
        );

        // Call the event service to create the meeting
        bool success = await eventService.createMeeting(meeting);

        if (success) {
          print('Meeting created successfully');
        } else {
          print('Failed to create meeting');
        }
      }
    } catch (e) {
      // Handle any exceptions that occur during the API call
      print('Error occurred: $e');
    }
  }

  Future<void> _fetchCoordinatesFromAddress(String address) async {
    try {
      // Get a list of locations from the provided address
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations[0]; // Take the first result

        // Get place details like pincode, state, city
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0]; // Take the first result

          // Update state variables with location details
          setState(() {
            selectedLatitude = location.latitude.toString();
            selectedLongitude = location.longitude.toString();
            selectedPincode = place.postalCode;
            selectedState = place.administrativeArea;
            selectedCity = place.locality;

            // Update the location controller text
            _locationController.text = address;
          });
        }
      }
    } catch (e) {
      print('Error fetching data for the address: $e');
    }
  }
  Future<void> _fetchAddressSuggestions(String input) async {
    setState(() {
      _isLoadingSuggestions = true; // Show loading indicator
    });

    try {
      final suggestions = await EventUtils.fetchAddressSuggestions(input, googlemapkey.mapkey); // Use your API key
      setState(() {
        _addressSuggestions = suggestions; // Update suggestions
      });
    } catch (e) {
      print("Error fetching suggestions: $e");
    } finally {
      setState(() {
        _isLoadingSuggestions = false; // Hide loading indicator
      });
    }
  }
  Future<void> _selectDateAndTime(TextEditingController dateController, TextEditingController timeController) async {
    // Select the date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Set the date in the controller
      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);

      // Automatically open the time picker after selecting the date
      await _selectTime(timeController);
    }
  }
}
