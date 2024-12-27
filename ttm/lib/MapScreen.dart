import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

class MapWithStreetViewPage extends StatefulWidget {
  const MapWithStreetViewPage({super.key});

  @override
  _MapWithStreetViewPageState createState() => _MapWithStreetViewPageState();
}

class _MapWithStreetViewPageState extends State<MapWithStreetViewPage> {
  static const platform = MethodChannel('com.ttm.streetview');
  GoogleMapController? _mapController;

  LatLng? _liveLocation; // To store the live location
  bool _isLoading = true; // Show loading indicator until location is fetched
  bool _isStreetViewActive = false; // Track if Street View is active

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch live location when the widget initializes
  }

  Future<void> _getCurrentLocation() async {
    // Check for location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the case when the user has denied the permission permanently
      // You can show a dialog or a message to the user
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _liveLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false; // Hide loading indicator
    });
  }

  // Launch Street View for the tapped location
  Future<void> _launchStreetView(LatLng position) async {
    try {
      await platform.invokeMethod('launchStreetView', {
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } on PlatformException catch (e) {
      print("Failed to launch Street View: '${e.message}'");
    }
  }

  // Toggle Street View
  void _toggleStreetView() {
    setState(() {
      _isStreetViewActive = !_isStreetViewActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map with Street View"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching location
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _liveLocation!, // Use live location as default
              zoom: 14.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (position) {
              if (_isStreetViewActive) {
                // If Street View is active, launch Street View for the tapped location
                _launchStreetView(position);
              }
            },
            markers: {
              if (_liveLocation != null)
                Marker(
                  markerId: MarkerId('live_location'),
                  position: _liveLocation!,
                ),
            },
          ),
          // Add a button to toggle Street View
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _toggleStreetView,
              child: Icon(_isStreetViewActive ? Icons.map : Icons.streetview),
              tooltip: _isStreetViewActive ? 'Show Map' : 'Show Street View',
            ),
          ),
        ],
      ),
    );
  }
}