import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedLocation{
  static LatLng _selectedLocation = const LatLng(0,0);
  static void setLocation(LatLng latLng){
    _selectedLocation = latLng;
  }
  static LatLng getLocation(){
    return _selectedLocation;
  }
}