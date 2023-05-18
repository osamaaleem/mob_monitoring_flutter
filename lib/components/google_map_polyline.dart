import 'package:google_map_polyline_new/google_map_polyline_new.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPolylineCustom{
  GoogleMapPolyline googleMapPolyline = GoogleMapPolyline(apiKey: 'AIzaSyDYul_aUQy43ZQpIfLOCwyL6lhrXCi6cpw');
  Future<List<LatLng>?> getRouteCoords(LatLng fist,LatLng second) async {
    return await googleMapPolyline.getCoordinatesWithLocation(
        origin: fist, destination: second, mode: RouteMode.driving);
    }
  }