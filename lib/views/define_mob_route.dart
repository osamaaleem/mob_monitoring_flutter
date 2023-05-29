import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_monitoring_flutter/components/google_map_polyline.dart';
import 'package:mob_monitoring_flutter/models/mob_coords.dart';
import 'package:mob_monitoring_flutter/networking/coordinate_network.dart';
import 'package:mob_monitoring_flutter/networking/mob_network.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'mob_demo.dart';

class DefineMobRoute extends StatefulWidget {
  DefineMobRoute({super.key, required this.id, required this.name});
  int id;
  String name;
  @override
  _DefineMobRouteState createState() => _DefineMobRouteState();
}

class _DefineMobRouteState extends State<DefineMobRoute> {
  GoogleMapController? _mapController;
  late List<LatLng> _routeCoords = [];
  late List<Marker> _markers = [];
  late List<LatLng> _selectedMarkers = [];
  //late List<LatLng> _polygonPoints = [];
  bool _isPolygonClosed = false;
  bool _isSaveButton = false;
  bool _isAsyncCall = false;
  LatLng _initialPosition = const LatLng(40.7128, -74.0060);
  List<LatLng> _initialPolygon = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select ${widget.name} route'),
        ),
        body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: _isAsyncCall,
            child: FutureBuilder(
              future: _determinePosition(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  Position p = snapshot.data!;
                  LatLng cp = LatLng(p.latitude, p.longitude);
                  _initialPolygon.add(cp);
                  _initialPosition = cp;
                  return Stack(children: [
                    GoogleMap(
                      markers: Set<Marker>.of(_markers),
                      // polygons: {
                      //   Polygon(
                      //       polygonId: const PolygonId('RedzonePolygon'),
                      //       points: _polygonPoints.isEmpty?_initialPolygon:_polygonPoints,
                      //       strokeColor: Colors.red,
                      //       fillColor: _isPolygonClosed
                      //           ? Colors.red.withOpacity(0.3)
                      //           : Colors.transparent,
                      //       strokeWidth: 2),
                      // },
                      mapToolbarEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      trafficEnabled: true,
                      buildingsEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 11,
                      ),
                      onMapCreated: _onMapCreated,
                      onTap: _handleMapTap,
                      onLongPress: _handleMapTap,
                      // markers: Set<Marker>.of(_markers),
                      //polylines: Set<Polyline>.of(_polylines),
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId('InitialRoute'),
                          points: _routeCoords,
                          width: 3,
                          color: Colors.blue,
                        ),
                      },
                    ),
                    Positioned(
                        top: 10,
                        left: 10,
                        child: FloatingActionButton.extended(
                          icon: _isSaveButton
                              ? const Icon(Icons.save)
                              : const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _isAsyncCall = true;
                              // _selectMarkersAndReturn();
                            });
                            _selectMarkersAndReturn();
                            // _selectMarkersAndReturn();
                            setState(() {
                              _isAsyncCall = false;
                            });
                          },
                          label: _isSaveButton
                              ? const Text('Save Route')
                              : const Text('Select Route'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                  ]);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _handleMapTap(LatLng tapLocation) {
    if (kDebugMode) {
      print('Marker Tapped');
      print(tapLocation);
    }
    if (_selectedMarkers.contains(tapLocation)) {
      _selectedMarkers.remove(tapLocation);
    } else {
      _selectedMarkers.add(tapLocation);
    }
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(tapLocation.toString()),
          position: tapLocation,
        ),
      );
      //_updatePolylines();
    });
  }

  // void _updatePolylines() {
  //   _polylines.clear();
  //   if (_selectedMarkers.length > 1) {
  //     _polylines.add(
  //       Polyline(
  //         polylineId: const PolylineId('route'),
  //         points: _selectedMarkers,
  //         color: Colors.red,
  //         width: 3,
  //       ),
  //     );
  //   }m
  // }

  void _selectMarkersAndReturn() async {
    if (!_isSaveButton) {
      for (int i = 0; i < _selectedMarkers.length - 1; i++) {
        var rPoints = await GoogleMapPolylineCustom.getRouteCoords(
            _selectedMarkers[i], _selectedMarkers[i + 1]);
        for (int i = 0; i < rPoints!.length; i++) {
          if (_routeCoords.contains(rPoints[i])) {
            continue;
          }
          _routeCoords.add(rPoints[i]);
          setState(() {
            _markers.clear();
          });
        }
      }
      if (kDebugMode) {
        print(_routeCoords);
      }
      setState(() {
        _isSaveButton = true;
      });
    } else {
      if (kDebugMode) {
        print(_routeCoords);
      }
      await CoordinateNetwork.addMobCoords(_routeCoords,widget.id);
      if(mounted){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MobDemo(
              routeLocations: _routeCoords,
              mobName: widget.name,
            ),
          ),
        );
      }
    }
  }

// Call this method inside a StatefulWidget's `setState` method to trigger the state update.

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}