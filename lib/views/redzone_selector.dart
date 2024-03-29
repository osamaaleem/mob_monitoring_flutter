import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_monitoring_flutter/models/redzone_coordinates.dart';
import 'package:mob_monitoring_flutter/networking/coordinate_network.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RedZoneSelectorMap extends StatefulWidget {
  RedZoneSelectorMap({super.key, required this.redZoneId});
  int redZoneId = 1;

  @override
  _RedZoneSelectorMapState createState() => _RedZoneSelectorMapState();
}

class _RedZoneSelectorMapState extends State<RedZoneSelectorMap> {
  GoogleMapController? _mapController;
  late List<Marker> _markers = [];
  late List<LatLng> _selectedMarkers = [];
  late List<LatLng> _polygonPoints = [];
  bool _isPolygonClosed = false;
  bool _isSaveButton = false;
  bool _isAsyncCall = false;
  LatLng _initialPosition = const LatLng(40.7128, -74.0060);
  List<LatLng> _initialPolygon = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Markers'),
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
                      polygons: {
                        Polygon(
                            polygonId: const PolygonId('RedzonePolygon'),
                            points: _polygonPoints.isEmpty?_initialPolygon:_polygonPoints,
                            strokeColor: Colors.red,
                            fillColor: _isPolygonClosed
                                ? Colors.red.withOpacity(0.3)
                                : Colors.transparent,
                            strokeWidth: 2),
                      },
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
                    ),
                    Positioned(
                        top: 10,
                        left: 10,
                        child: FloatingActionButton.extended(
                      icon: _isSaveButton
                          ? const Icon(Icons.save)
                          : const Icon(Icons.add),
                      onPressed: _selectMarkersAndReturn,
                      label: _isSaveButton
                          ? const Text('Save')
                          : const Text('Select Markers'),
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
    if(kDebugMode){
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
  //   }
  // }

  void _selectMarkersAndReturn() {
    // Navigator.pop(context, _selectedMarkers);
    setState(() {
      if (!_isSaveButton) {
        _isSaveButton = true;
        _isPolygonClosed = true;
        setState(() {
          _polygonPoints = _selectedMarkers;
          _markers.clear();
        });
        //_selectedMarkers = [];
      } else {
        List<RedZoneCoordinates> redZoneCoordinates = [];
        for (int i = 0; i < _polygonPoints.length; i++) {
          redZoneCoordinates.add(RedZoneCoordinates(
              redZoneID_FK: widget.redZoneId,
              redZoneLat: _polygonPoints[i].latitude,
              redZoneLon: _polygonPoints[i].longitude));
        }
        setState(() {
          _isAsyncCall = true;
          CoordinateNetwork.addRedzoneCoords(redZoneCoordinates)
              .then((value) {
            setState(() {
              _isAsyncCall = false;
            });
            if(value){
              setState(() {
                _isAsyncCall = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Redzone Coordinates Added Successfully'),
              ));
              //Navigator.of(context).popUntil((route) => route.settings.name == '/AdminDash');
            }else{
              setState(() {
                _isAsyncCall = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Error Adding Redzone Coordinates'),
              ));
            }
            Navigator.pop(context, _selectedMarkers);
          });
        });
      }
    });
  }

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
