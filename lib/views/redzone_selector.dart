import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullScreenMap extends StatefulWidget {
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  GoogleMapController? _mapController;
  List<Marker> _markers = [];
  List<LatLng> _selectedMarkers = [];
  Set<Polyline> _polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Markers'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.from(_markers),
            polylines: _polylines,
            onTap: _handleMapTap,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194), // Set your desired initial map position
              zoom: 12.0,
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: ElevatedButton(
              onPressed: () {
                _selectMarkersAndReturn();
              },
              child: Text('Select'),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _handleMapTap(LatLng tapLocation) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(tapLocation.toString()),
          position: tapLocation,
          onTap: () {
            setState(() {
              if (_selectedMarkers.contains(tapLocation)) {
                _selectedMarkers.remove(tapLocation);
              } else {
                _selectedMarkers.add(tapLocation);
              }
              _updatePolylines();
            });
          },
        ),
      );
      _updatePolylines();
    });
  }

  void _updatePolylines() {
    _polylines.clear();
    if (_selectedMarkers.length > 1) {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: _selectedMarkers,
          color: Colors.red,
          width: 3,
        ),
      );
    }
  }

  void _selectMarkersAndReturn() {
    Navigator.pop(context, _selectedMarkers);
  }
}
