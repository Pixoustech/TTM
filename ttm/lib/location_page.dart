import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ttm/Constant.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({Key? key}) : super(key: key);

  // List of locations
  static const List<LatLng> _locations = [
    LatLng(11.023646, 76.968289), // Example Location 1
    LatLng(11.021000, 76.970000), // Example Location 2
    LatLng(11.025000, 76.965000), // Example Location 3
  ];

  // Create a list of points to represent the route from Location 1 to Location 2
  static List<LatLng> _createBikeRoute() {
    return [
      _locations[0], // Start point
      LatLng(11.022500, 76.968500), // Intermediate point 1
      LatLng(11.022000, 76.969000), // Intermediate point 2
      _locations[1], // End point
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _locations[0], // Set the initial center to the first location
          initialZoom: 13.0, // Set the zoom level
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _locations.map((location) {
              return Marker(
                width: 80,
                height: 80,
                point: location,
                child: Icon(
                  Icons.location_on,
                  size: 40.0, // Adjust the size as needed
                  color: AppColors.concolor, // Set the color of the icon
                ),
              );
            }).toList(),
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: _createBikeRoute(), // Use the bike route points for the polyline
                strokeWidth: 4.0, // Width of the line
                color: Colors.green, // Color of the line (change to green for biking)
                // Optionally, you can make it dashed by modifying the stroke shape
                // This requires additional customization in FlutterMap.
              ),
            ],
          ),
        ],
      ),
    );
  }
}
