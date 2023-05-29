// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_map_polyline_new/google_map_polyline_new.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapContainer extends StatefulWidget {
//   MapContainer({super.key, this.width = 380,this.height = 280});
//   MapContainer.withCoords({super.key, this.width = 380,this.height = 280, required this.mobId});
//   double height;
//   double width;
//   int? mobId;
//   @override
//   _MapContainerState createState() => _MapContainerState();
// }
//
// class _MapContainerState extends State<MapContainer> {
//   final Completer<GoogleMapController> _controller = Completer();
//   final Set<Marker> _markers = {};
//   final List<LatLng> _points = const [
//     LatLng(37.7749, -122.4194),
//     LatLng(37.3382, -121.8863),
//   ];
//   List<LatLng> _routeCoords = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _routeCoords = widget.routeCoords!;
//     _updaterouteCoords();
//   }
//
//
//   Future<void> _updaterouteCoords() async {
//     while (true) {
//       await Future.delayed(const Duration(seconds: 1));
//       setState(() {
//         _routeCoords = _points;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.secondaryContainer,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: Colors.grey,
//           width: 1,
//         ),
//       ),
//       height: widget.height,
//       width: widget.width,
//       child: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _points.first,
//           zoom: 10,
//         ),
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         markers: _markers,
//         polylines: {
//           Polyline(
//             polylineId: const PolylineId('routeCoords'),
//             color: Colors.red,
//             points: _routeCoords,
//           ),
//         },
//       ),
//     );
//   }
// }
