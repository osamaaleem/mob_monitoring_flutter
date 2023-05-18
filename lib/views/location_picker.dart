import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_monitoring_flutter/models/selected_location.dart';

class LocationPicker extends StatefulWidget {
  LocationPicker({super.key,required this.position});
  TextEditingController position;
  //TextEditingController lonCont;

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng _initialPosition = const LatLng(40.7128, -74.0060);
  //LatLng _selectedPosition =;

  void _onMapCreated(GoogleMapController controller) {
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double btnPadding = screenWidth-85;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(right: btnPadding,bottom: 15),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: FutureBuilder(
        future: _determinePosition(),
        builder: (ctx,snapshot){
          if(snapshot.hasData){
            Position p = snapshot.data!;
            LatLng cp = LatLng(p.latitude, p.longitude);
            _initialPosition = cp;
            return buildGoogleMap();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  GoogleMap buildGoogleMap() {
    return GoogleMap(
      mapToolbarEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      trafficEnabled: true,
      buildingsEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 12,
      ),
      onMapCreated: _onMapCreated,
      onTap: (LatLng position) {
        setState(() {
          //_selectedPosition = position;
          SelectedLocation.setLocation(position);
          String lat = SelectedLocation.getLocation().latitude.toString();
          String lon = SelectedLocation.getLocation().longitude.toString();
          widget.position.text = "$lat,$lon";
        });
      },
      markers: {
        //if (_selectedPosition != null)
          Marker(
            markerId: const MarkerId('selected_position'),
            position: SelectedLocation.getLocation(),
          ),
      },
    );
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