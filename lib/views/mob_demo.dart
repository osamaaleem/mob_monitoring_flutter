import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_monitoring_flutter/components/google_map_polyline.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MobDemo extends StatefulWidget {
  bool _startDemo = false;
  MobDemo({Key? key, required this.routeLocations,required this.mobName}) : super(key: key);
  List<LatLng> routeLocations = [];
  String mobName;
  @override
  State<MobDemo> createState() => _MobDemoState();
}

class _MobDemoState extends State<MobDemo> {
  @override
  initState() {
    super.initState();
    routeLocations = widget.routeLocations;
  }

  late List<LatLng> demoLocations = [];
  List<LatLng> routeLocations = [];
  Stream<LatLng> moveMob() async* {
    for (int i = 0; i < routeLocations.length; i++) {
      await Future.delayed(const Duration(seconds: 1));
      if(widget._startDemo == false) {
        i = 0;
      }
      yield routeLocations[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController? _mapController;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mob Demo: ${widget.mobName}'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          // If _startDemo is true call moveMob() in stream else return empty stream
          stream: widget._startDemo ? moveMob() : const Stream.empty(),
          // stream: moveMob(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return Stack(children: [
                GoogleMap(
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('InitialRoute'),
                      points: routeLocations,
                      width: 3,
                      color: Colors.blue,
                    ),
                  },
                  initialCameraPosition:
                      CameraPosition(target: routeLocations[0], zoom: 15),
                ),
                Positioned(
                    top: 10,
                    left: 10,
                    child: FloatingActionButton.extended(
                      icon: widget._startDemo
                          ? const Icon(Icons.stop_circle)
                          : const Icon(Icons.not_started),
                      onPressed: () {
                        setState(() {
                          widget._startDemo = !widget._startDemo;
                        });
                      },
                      label: widget._startDemo
                          ? const Text('Stop')
                          : const Text('Start'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
              ]);
            } else {
              demoLocations.add(snapshot.data!);
              return Stack(
                children: [
                  GoogleMap(
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('InitialRoute'),
                        points: routeLocations,
                        width: 3,
                        color: Colors.blue,
                      ),
                      Polyline(
                          polylineId: const PolylineId('MobDemoRoute'),
                          points: demoLocations,
                          width: 3,
                          color: Colors.red)
                    },
                    markers: {
                      Marker(
                          markerId: const MarkerId('MobDemoMarker'),
                          position: widget._startDemo? demoLocations.last: routeLocations[0]),
                    },
                    initialCameraPosition: CameraPosition(
                        target: demoLocations.length > 5
                            ? demoLocations[demoLocations.length - 2]
                            : routeLocations[0],
                        zoom: 15),
                  ),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: FloatingActionButton.extended(
                        icon: widget._startDemo
                            ? const Icon(Icons.stop_circle)
                            : const Icon(Icons.not_started),
                        onPressed: () {
                          setState(() {
                            if(widget._startDemo){
                              demoLocations.clear();
                            }
                            widget._startDemo = !widget._startDemo;
                          });
                        },
                        label: widget._startDemo
                            ? const Text('Stop')
                            : const Text('Start'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}


