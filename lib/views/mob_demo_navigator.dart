import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_monitoring_flutter/models/mob_coords.dart';
import 'package:mob_monitoring_flutter/networking/coordinate_network.dart';
import 'package:mob_monitoring_flutter/views/define_mob_route.dart';
import 'mob_demo.dart';

class MobDemoNavigator extends StatefulWidget {
  MobDemoNavigator(
      {Key? key,
      required this.id,
      required this.mobName,
      required this.demonstrate})
      : super(key: key);
  int id;
  String mobName;
  bool demonstrate;
  @override
  State<MobDemoNavigator> createState() => _MobDemoNavigatorState();
}

class _MobDemoNavigatorState extends State<MobDemoNavigator> {
  bool _coordAvailable = false;
  List<LatLng> _preDefCoords = [];
  Future<bool> _getPreDefCoords(int id) async {
    var mobCoords = await CoordinateNetwork.getPreDefCoords(id);
    for (MobCoordinates m in mobCoords) {
      _preDefCoords.add(LatLng(m.MobLat!, m.MobLon!));
    }
    if (_preDefCoords.isNotEmpty) {
      setState(() {
        _coordAvailable = true;
      });
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<void> navigator() async {
    bool coordsAreAvailable = await _getPreDefCoords(widget.id);
    if (coordsAreAvailable) {
      if (!widget.demonstrate && context.mounted) {
        Navigator.of(context)
            .popUntil((route) => route.settings.name == '/AdminDash');
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MobDemo(
                    mobName: widget.mobName, routeLocations: _preDefCoords)));
      }
    } else {
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DefineMobRoute(
                      id: widget.id,
                      name: widget.mobName,
                      demonstrate: widget.demonstrate,
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Looking For Coordinates..."),
        ),
        body: FutureBuilder(
          future: navigator(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
