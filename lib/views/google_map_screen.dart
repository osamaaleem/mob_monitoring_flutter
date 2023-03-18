import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_monitoring_flutter/models/locations.dart' as locations;
import 'package:mob_monitoring_flutter/networking/mob_network.dart';


class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    final mobs = await MobNetwork().getActiveMobs();
    setState(() {
      _markers.clear();
      for (final mob in mobs) {
        if(mob.mobStartLat == null || mob.mobStartLon == null){
          continue;
        }
        final marker = Marker(
          markerId: MarkerId(mob.name!),
          position: LatLng(mob.mobStartLat!, mob.mobStartLon!),
          infoWindow: InfoWindow(
            title: mob.name!,
            snippet: mob.startDate,
          ),
        );
        _markers[mob.name!] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}