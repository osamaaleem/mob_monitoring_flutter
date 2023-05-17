import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapContainer extends StatelessWidget {
  final List<LatLng> routeLocations;
  final double boxHeight;
  final double boxWidth;

  MapContainer({super.key, required this.routeLocations, required this.boxHeight, required this.boxWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: boxHeight,
      width: boxWidth, // Adjust the height as per your requirement
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: routeLocations.first,
          zoom: 15.0,
        ),
        markers: Set<Marker>.from(
          routeLocations.map(
                (location) => Marker(
              markerId: MarkerId(location.toString()),
              position: location,
            ),
          ),
        ),
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            points: routeLocations,
            color: Colors.red,
            width: 3,
          ),
        },
      ),
    );
  }
}
