import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mob_monitoring_flutter/models/ip_address.dart';
import '../models/redzone_coordinates.dart';
class CoordinateNetwork{
  static final String _baseUser = "https://${IPAddress.getIP()}/api/redzones";
  static Future<bool> addRedzoneCoords(List<RedZoneCoordinates> coords) async {
    final url = '$_baseUser/addredzonecoords';
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
}