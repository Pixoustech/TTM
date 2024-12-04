import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Comman_pages/Constant.dart';
import '../Comman_pages/Navigation_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../MapScreen.dart';

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
  final TextEditingController _toTimeController = TextEditingController();

  String? _selectedFileName;
  String? _selectedMode;
  String? _selectedPriority;
  List<String> _addressSuggestions = [];
  bool _isLoadingSuggestions = false; // To show loading indicator

  @override
  void initState() {
    super.initState();
    _selectedMode = 'offline';
    _venueOrLinkController.text = 'Venue';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildDescriptionField(),
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
        ] else
          if (_currentView == 'meeting') ...[
            _buildTextField('Meeting Name', _meetingNameController),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextFieldWithCalendar(
                      'From Date', _fromDateController),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                  _buildTextFieldWithTime('From Time', _fromTimeController),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child:
                  _buildTextFieldWithCalendar('To Date', _toDateController),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextFieldWithTime('To Time', _toTimeController),
                ),
              ],
            ),
            _buildTextField('Location', _locationController),
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
              suffixIcon: IconButton(
                icon: const Icon(Icons.location_on),
                onPressed: () async {
                  var status = await Permission.location.request();
                  if (status.isGranted) {
                    final LatLng? selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapWithStreetViewPage()),
                    );
                    if (selectedLocation != null) {
                      controller.text =
                      '${selectedLocation.latitude}, ${selectedLocation.longitude}';
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Location permission denied')),
                    );
                  }
                },
              ),
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
  Widget _buildTextFieldWithCalendar(String label,
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
            // Decrease font size
            cursorColor: AppColors.concolor,
            // Set cursor color
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.concolor, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 4.0, horizontal: 12.0), // Adjust content padding
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
            style: GoogleFonts.montserrat(fontSize: 14), // Decrease font size
            cursorColor: AppColors.concolor, // Set cursor color
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.concolor, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 4.0, horizontal: 12.0), // Adjust content padding
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

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _dueDateController.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = "${picked.hour}:${picked.minute}";
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
    bool isSelected =
        _selectedPriority == label; // Check if this box is selected

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = label; // Update the selected priority
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.black : Colors.black45),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? color.withOpacity(0.2)
              : Colors.transparent, // Change background color if selected
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
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal, // Change text weight if selected
                color: isSelected
                    ? color
                    : Colors.black, // Change text color if selected
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
                    _venueOrLinkController.text = 'Venue';
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
                    _venueOrLinkController.text = 'Link';
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
          readOnly: true,
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
          ),
        ),
        const SizedBox(height: 16),
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
                cursorColor: AppColors.concolor,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.concolor, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /* Widget _buildPriorityBox(String label, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle priority selection
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 6,
              backgroundColor: color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }*/

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
                  // Handle create action
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

  Future<List<String>> fetchAddressSuggestions(String input) async {
    final String apiKey = googlemapkey.mapkey; // Replace with your API key
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> suggestions = [];
      for (var prediction in data['predictions']) {
        suggestions.add(prediction['description']);
      }
      return suggestions;
    } else {
      throw Exception('Failed to load suggestions');
    }
  }


  Future<void> _fetchAddressSuggestions(String input) async {
    setState(() {
      _isLoadingSuggestions = true; // Show loading indicator
    });
    try {
      final suggestions = await fetchAddressSuggestions(input);
      setState(() {
        _addressSuggestions = suggestions;
      });
    } catch (e) {
      print("Error fetching suggestions: $e");
    } finally {
      setState(() {
        _isLoadingSuggestions = false; // Hide loading indicator
      });
    }
  }
}