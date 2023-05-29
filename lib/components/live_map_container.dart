import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_monitoring_flutter/networking/coordinate_network.dart';
import 'package:mob_monitoring_flutter/networking/live_map_network.dart';

import '../models/mob_coords.dart';

class LiveMapContainer extends StatefulWidget {
  LiveMapContainer({super.key, this.width = 380,this.height = 280});
  LiveMapContainer.withCoords({super.key, this.width = 380,this.height = 280, required this.mobId, required this.isLive});
  double height;
  double width;
  int? mobId;
  bool isLive = false;
  @override
  _LiveMapContainerState createState() => _LiveMapContainerState();
}

class _LiveMapContainerState extends State<LiveMapContainer> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final List<LatLng> _points = const [
    LatLng(37.7749, -122.4194),
    LatLng(37.3382, -121.8863),
  ];
  List<LatLng> _routeCoords = [];
  Stream<dynamic> getLiveCoords(int id) async*{
    while(widget.isLive){
      Future.delayed(const Duration(seconds: 5));
      MobCoordinates coords = await LiveMapNetwork.getLiveCoords(id);
      yield coords;
    }
    yield const Stream.empty();
  }
  @override
  void initState() {
    super.initState();
    //_routeCoords = widget.routeCoords!;
    // _updaterouteCoords();
  }


  // Future<void> _updaterouteCoords() async {
  //   while (true) {
  //     await Future.delayed(const Duration(seconds: 1));
  //     setState(() {
  //       _routeCoords = _points;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getLiveCoords(widget.mobId!),
      builder: (ctx,snapshot){
       if(snapshot.hasData || _routeCoords.isNotEmpty){
         if(snapshot.hasData){
           if(_routeCoords.contains(snapshot.data)){
             _routeCoords;
           }
           else{
             _routeCoords.add(snapshot.data);
           }
         }
         return Container(
           decoration: BoxDecoration(
             color: Theme.of(context).colorScheme.secondaryContainer,
             borderRadius: BorderRadius.circular(10),
             border: Border.all(
               color: Colors.grey,
               width: 1,
             ),
           ),
           height: widget.height,
           width: widget.width,
           child: GoogleMap(
             initialCameraPosition: CameraPosition(
               target: _points.last,
               zoom: 10,
             ),
             polylines: {
               Polyline(
                 polylineId: const PolylineId('mob_route'),
                 color: Colors.red,
                 width: 3,
                 points: _routeCoords,
               ),
             },
             markers: {
               Marker(markerId: const MarkerId('mob_current_location'), position: _points.last),
             },
             onMapCreated: (GoogleMapController controller) {
               _controller.complete(controller);
             },
           ),
         );
       }
       else{
         return const Center(
           child: CircularProgressIndicator(semanticsLabel: 'Getting Mob Coordinates',),
         );
       }
      },
    );
  }
}
