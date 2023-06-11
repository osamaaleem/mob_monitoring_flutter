import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mob_monitoring_flutter/models/ip_address.dart';

import '../models/drone.dart';

class DroneNetwork {
  final String apiUrl = "https://${IPAddress.getIP()}/api/drones";

  DroneNetwork();

  Future<List<Drone>> fetchDrones() async {
    final url = '$apiUrl/GetAllDrones';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode != 200){
      print(response.statusCode);
    }
    final jsonData = json.decode(response.body);
    if(response.statusCode != 200){
      print(response.statusCode);
    }
    List<Drone> drones = [];
    for (var item in jsonData) {
      drones.add(Drone.fromJson(item));
    }
    if(kDebugMode){
      print(drones);
    }
    return drones;
  }
 Future<http.Response> UpdateDrone(Drone d) async {
    final url = '$apiUrl/UpdateDrone';
    final response = await http.post(Uri.parse(url),body: d.toJson());
    if(response.statusCode == 200){
      return response;
    }
    if(response.statusCode == HttpStatus.internalServerError){
      if(kDebugMode){
        print(HttpStatus.internalServerError);
      }
    }
    return response;
  }
 Future<http.Response> DeleteDrone(int droneId) async {
    final url = '$apiUrl/DeleteDrone?id=$droneId';
    final response = await http.delete(Uri.parse(url));
    if(response.statusCode == 200){
      return response;
    }
    if(response.statusCode == HttpStatus.internalServerError){
      if(kDebugMode){
        print(HttpStatus.internalServerError);
      }
    }
    return response;
  }

  Future<bool> addDrone(Drone drone) async {
    final url = '$apiUrl/addDrone';
    final response = await http.post(Uri.parse(url),body: drone.toJson());
    if(response.statusCode == 200){
      return true;
    }
    if(response.statusCode == HttpStatus.internalServerError){
      if(kDebugMode){
        print(HttpStatus.internalServerError);
      }
    }
    return false;
  }
}
