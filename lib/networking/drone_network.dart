import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mob_monitoring_flutter/models/ip_address.dart';

import '../models/drone.dart';

class DroneNetwork {
  final String apiUrl = "https://${IPAddress.getIP()}:44381/api/drones";

  DroneNetwork();

  Future<List<Drone>> fetchDrones() async {
    final url = '$apiUrl/getalldrone';
    final response = await http.get(Uri.parse(url));
    final jsonData = json.decode(response.body);
    List<Drone> drones = [];
    for (var item in jsonData) {
      drones.add(Drone.fromJson(item));
    }
    return drones;
  }

  Future<List<Drone>> getAvailableDrones() async {
    final drones = await fetchDrones();
    return drones.where((drone) => drone.isAvailable).toList();
  }

  Future<List<Drone>> getChargedDrones() async {
    final drones = await fetchDrones();
    return drones.where((drone) => drone.isCharged).toList();
  }
}
