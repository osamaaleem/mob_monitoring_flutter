import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/components/operator_dash_drawer.dart';
import 'package:mob_monitoring_flutter/models/mob_coords.dart';

import '../models/mob.dart';
import '../models/user.dart';
import '../networking/mob_network.dart';

class OperatorView extends StatefulWidget {
  OperatorView({Key? key, required this.u}) : super(key: key);
  User u;
  @override
  State<OperatorView> createState() => _OperatorViewState();
}

class _OperatorViewState extends State<OperatorView> {
  late List<LatLng> _polygonPoints = [];
  Mob mob = Mob();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer:
            OperatorDashDrawer(email: widget.u.email, username: widget.u.name),
        appBar: AppBar(
          title: const Text("Operator Dashboard"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 25.0, 8.0, 15.0),
          child: FutureBuilder(
            future: MobNetwork().getMobByOperatorId(widget.u.id!),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                mob = snapshot.data as Mob;
                return FutureBuilder(
                  future: _determinePosition(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      Position p = snapshot.data as Position;
                      LatLng cp = LatLng(p.latitude, p.longitude);
                      return Column(
                        children: [
                          Container(),
                          CustomSizedBox.medium(),
//Google Map in container here to select Markers and save to list
                          GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: cp,
                                zoom: 15,
                              ),
                              polylines: {
                                Polyline(
                                  polylineId: const PolylineId("Mob Path"),
                                  points: _polygonPoints,
                                  color: Colors.red,
                                  width: 5,
                                )
                              },
                              markers: {
                                Marker(
                                  markerId: const MarkerId("Current Location"),
                                  position: _polygonPoints.isEmpty
                                      ? cp
                                      : _polygonPoints.last,
                                )
                              },
                              onTap: (LatLng latLng) {
                                setState(() {
                                  _polygonPoints.add(latLng);
                                });
                                MobCoordinates m = MobCoordinates(
                                  MobID_FK: mob.mobID,
                                  MobLat: latLng.latitude,
                                  MobLon: latLng.longitude,
                                );
                              }),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
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
