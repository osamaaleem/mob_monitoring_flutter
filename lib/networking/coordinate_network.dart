import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mob_monitoring_flutter/models/ip_address.dart';
import 'package:mob_monitoring_flutter/models/mob_coords.dart';
import '../models/redzone_coordinates.dart';
class CoordinateNetwork{
  static final String _baseUser = "https://${IPAddress.getIP()}/api";
  static Future<bool> addRedzoneCoords(List<RedZoneCoordinates> coords) async {
    final url = '$_baseUser/redzones/addredzonecoords';
    var jsonList = [];
    for(var i = 0; i < coords.length; i++){
      jsonList.add(coords[i].toJson());
    }
    if(kDebugMode){
      print("List of Coords $jsonList");
    }
    //var response = await http.post(Uri.parse(url), body: json.encode({"rcList": jsonList}));
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(jsonList),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    if(response.statusCode == 200){
      return Future.value(true);
  }
    else{
      return Future.value(false);
    }
  }

  static Future<List<RedZoneCoordinates>> getRedzoneCoords(int redzoneId) async {
    final url = '$_baseUser/redzone/getredzonecoords/$redzoneId';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final List<dynamic> redzoneCoords = json.decode(response.body);
      return redzoneCoords.map((json) => RedZoneCoordinates.fromJson(json)).toList();
    }
    else{
      return Future.value(null);
    }
  }
  static Future<bool> addMobCoords(List<LatLng> coords, int id) async {
    final url = '$_baseUser/MobCoord/AddMobCoords';
    var jsonList = [];
    for(var i = 0; i < coords.length; i++){
      //jsonList.add(coords[i].toJson());
      //jsonList.add(coords[i].preDefToJson());
      var mCoord = MobCoordinates(
        coordinateID: null,
        MobID_FK: id,
        MobLat: coords[i].latitude,
        MobLon: coords[i].longitude,
      );
      jsonList.add(mCoord.preDefToJson());
    }
    if(kDebugMode){
      print("List of Coords $jsonList");
    }
    //var response = await http.post(Uri.parse(url), body: json.encode({"rcList": jsonList}));
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(jsonList),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    if(response.statusCode == 200){
      return Future.value(true);
    }
    else{
      return Future.value(false);
    }
  }

  static Future<List<MobCoordinates>> getMobCoords(int mobId) async {
    final url = '$_baseUser/MobCoord/GetMobCoords/$mobId';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final List<dynamic> mobCoords = json.decode(response.body);
      return mobCoords.map((json) => MobCoordinates.fromJson(json)).toList();
    }
    else{
      return Future.value(null);
    }
  }

  static Future<List<MobCoordinates>> getPreDefCoords(int mobId) async {
    final url = '$_baseUser/MobCoord/getpredefcoords?mobid=$mobId';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final List<dynamic> mobCoords = json.decode(response.body);
      return mobCoords.map((json) => MobCoordinates.preDefFromJson(json)).toList();
    }
    else{
      return Future.value(null);
    }
  }
}