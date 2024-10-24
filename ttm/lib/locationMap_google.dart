import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ttm/Constant.dart';

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

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(10.839396, 77.186328),
    zoom: 15,
  );

  final Set<Marker> _markers = {};
  final List<LatLng> _markerPositions = [
    LatLng(10.839396, 77.186328), // Marker 1
    LatLng(10.837048, 77.187851), // Marker 2
    LatLng(11.023646, 76.968289), // Marker 3
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
          // Removed the infoWindow property
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

      // Move the camera to the selected marker
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map'),
      foregroundColor: Colors.white,
      backgroundColor: AppColors.concolor),
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
          if (_isInfoWindowVisible && _address != "Fetching address...")
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 90,
              top: _calculateInfoWindowPosition().dy,
              child: GestureDetector(
                onTap: _hideInfoWindow,
                child: _customInfoWindow(),
              ),
            ),
        ],
      ),
    );
  }

  Offset _calculateInfoWindowPosition() {
    if (_selectedMarkerPosition == null) return Offset(0, 0);
    double markerOffsetY = 100.0;
    return Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2 - markerOffsetY);
  }

  Widget _customInfoWindow() {
    return Container(
      width: 118,
      height: 100,
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('App Design Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              _infoRow(Icons.date_range, 'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}'),
              const SizedBox(height: 4),
              _infoRow(Icons.access_time, 'Time: ${DateFormat('HH:mm:ss').format(DateTime.now())}'),
              const SizedBox(height: 4),
              _infoRow(Icons.location_on, 'Address: $_address'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _hideInfoWindow() {
    setState(() {
      _isInfoWindowVisible = false;
    });
  }
}
