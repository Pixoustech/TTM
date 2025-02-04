import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

import '../Comman_pages/Constant.dart';
import '../Comman_pages/Navigation_page.dart';

class EventData {
  final String id;
  final String userId;
  final String eventId;
  final String eventName;
  final String eventDate; // Date without time
  final String eventDateFromTime; // Date with time
  final String eventDateToTime; // Date with time
  final String fromTime;
  final String toTime;
  final String venue;
  final String location;
  final String priority;
  final String description;
  final String eventType;
  final String eventMode;
  final String statusId;
  final bool isSelfEvent;
  final String createdBy;
  final String createdByUserName;
  final String createdDate;

  EventData({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventDateFromTime,
    required this.eventDateToTime,
    required this.fromTime,
    required this.toTime,
    required this.venue,
    required this.location,
    required this.priority,
    required this.description,
    required this.eventType,
    required this.eventMode,
    required this.statusId,
    required this.isSelfEvent,
    required this.createdBy,
    required this.createdByUserName,
    required this.createdDate,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      userId: json['userId'] ?? '',
      eventId: json['eventId'] ?? '',
      eventName: json['eventName'] ?? '',
      eventDate: json['eventDate'] ?? '',
      eventDateFromTime: json['eventDateFromTime'] ?? '',
      eventDateToTime: json['eventDateToTime'] ?? '',
      fromTime: json['fromTime'] ?? '',
      toTime: json['toTime'] ?? '',
      venue: json['venue'] ?? '',
      location: json['location'] ?? '',
      priority: json['priority'] ?? '',
      description: json['description'] ?? '',
      eventType: json['eventType'] ?? '',
      eventMode: json['eventMode'] ?? '',
      statusId: json['statusId'] ?? '',
      isSelfEvent: json['isSelfEvent'] ?? false,
      createdBy: json['createdBy'] ?? '',
      createdByUserName: json['createdByUserName'] ?? '',
      createdDate: json['createdDate'] ?? '', id: json['eventId'] ?? '',
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  bool _isInfoWindowVisible = false;
  String _address = "Fetching address...";
  Marker? _selectedMarker;
  LatLng? _selectedMarkerPosition;
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<EventData> _events = [];

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(10.839396, 77.186328),
    zoom: 15,
  );

  final Set<Marker> _markers = {};
  final List<LatLng> _markerPositions = [
    LatLng(10.839396, 77.186328),
    LatLng(10.837048, 77.187851),
    LatLng(11.023646, 76.968289),
  ];

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    for (int i = 0; i < _markerPositions.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('marker$i'),
          position: _markerPositions[i],
          onTap: () => _onMarkerTapped(i),
        ),
      );
    }
  }

  void _onMarkerTapped(int index) {
    setState(() {
      _isInfoWindowVisible = true;
      _selectedMarker = _markers.firstWhere((marker) => marker.markerId == MarkerId('marker$index'));
      _selectedMarkerPosition = _markerPositions[index];
      _getAddressFromLatLng(_markerPositions[index]);

      mapController.moveCamera(CameraUpdate.newLatLng(_markerPositions[index]));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.moveCamera(CameraUpdate.newLatLng(initialPosition.target));
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _address = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
        String month = DateFormat('MM').format(picked);
        String year = DateFormat('yyyy').format(picked);
        fetchEvents(month, year).then((events) {
          setState(() {
            _events = events; // Store fetched events
          });
        });
      });
    }
  }

  Future<List<EventData>> fetchEvents(String month, String year) async {
    final String url = '/Event/User_Calender_Get?Month=$month&Year=$year';

    try {
      final response = await AppApi.dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> eventsJson = response.data['data']; // Adjust this line based on your actual response structure
        return eventsJson.map((eventJson) => EventData.fromJson(eventJson)).toList();
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }


  List<EventData> _filterTasks() {
    return _events.where((event) => event.eventDate == _selectedDate).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft, // Aligns text to the left
          child: Text(
            'Map',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back arrow
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Navigation()),
            );
          },
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.concolor,
      ),

      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: initialPosition,
            markers: _markers,
            onCameraMove: (_) {
              _hideInfoWindow(); // Hide the info window when the camera moves
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                        hintText: _selectedDate,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filterTasks().length,
                itemBuilder: (context, index) {
                  final task = _filterTasks()[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to event detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailPage(
                              title: task.eventName,
                              description: task.description,
                              priority: task.priority,
                              status: task.eventType,
                              date: task.eventDate,
                              location: task.location,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 120,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.eventName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                task.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text('Date: ${task.eventDate}'),
                              Text('Location: ${task.location}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _hideInfoWindow() {
    setState(() {
      _isInfoWindowVisible = false;
    });
  }
}

// Dummy EventDetailPage for demonstration purposes
class EventDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String priority;
  final String status;
  final String date;
  final String location;

  EventDetailPage({
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: $description'),
            SizedBox(height: 8),
            Text('Priority: $priority'),
            SizedBox(height: 8),
            Text('Status: $status'),
            SizedBox(height: 8),
            Text('Date: $date'),
            SizedBox(height: 8),
            Text('Location: $location'),
          ],
        ),
      ),
    );
  }
}