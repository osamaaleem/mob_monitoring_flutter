import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_monitoring_flutter/models/mob_coords.dart';
import 'package:mob_monitoring_flutter/networking/coordinate_network.dart';
import 'package:mob_monitoring_flutter/views/define_mob_route.dart';
import 'mob_demo.dart';
import 'view_drones.dart';

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Looking For Coordinates..."),
      ),
      // body: FutureBuilder(
      //   future: _getPreDefCoords(widget.id),
      //   builder: (ctx,snapshot){
      //     if(snapshot.hasData){
      //       bool coordsAreAvaialable = snapshot.data!;
      //       if(coordsAreAvaialable){
      //         //return Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDrones()))));
      //         if(widget.demonstrate){
      //           Navigator.of(context)
      //               .popUntil((route) => route.settings.name == '/AdminDash');
      //         }
      //         else{
      //           return MobDemo(mobName: widget.mobName, routeLocations: _preDefCoords);
      //         }
      //
      //       }
      //       else if(!_coordAvailable){
      //         return DefineMobRoute(id: widget.id, name: widget.mobName);
      //       }
      //       else{
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //     }
      //     else{
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //     ); }
      //   },
      // ),
    );
  }
}
