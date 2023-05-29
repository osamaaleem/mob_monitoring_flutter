import 'dart:convert';

import '../models/ip_address.dart';
import '../models/mob_coords.dart';
import 'package:http/http.dart' as http;

class LiveMapNetwork{
  static final String apiUrl = "https://${IPAddress.getIP()}/api/LiveData";
  static Future<MobCoordinates> getLiveCoords(int id){
    return http.get(Uri.parse('$apiUrl/getCoord?Mobid=$id')).then((response){
      if(response.statusCode == 200){
        final responseString = jsonDecode(response.body);
        return MobCoordinates.fromJson(responseString);
      }
      else{
        return Future.error("Error getting live coords");
      }
    });
  }
}