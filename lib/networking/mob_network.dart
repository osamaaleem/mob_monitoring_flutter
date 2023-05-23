import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:mob_monitoring_flutter/models/ip_address.dart';

import '../models/mob.dart';

class MobNetwork {
  final String _baseUrl = "https://${IPAddress.getIP()}/api/mobs";
  //final String _baseUrl = "https://192.168.1.5/api/mobs";

  Future<List<Mob>> getActiveMobs() async {
    final url = '$_baseUrl/getactivemobs';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Mob.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch mobs');
    }
  }

  //Future<List<LatLng>> get

  Future<List<Mob>> getInActiveMobs() async {
    final url = '$_baseUrl/getinactivemobs';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Mob.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch mobs');
    }
  }
  Future<List<Mob>> getAllMobs() async {
    final url = '$_baseUrl/getallmobs';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      if (kDebugMode) {
        //print(response.body);
      }
      return jsonList.map((json) => Mob.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch mobs');
    }
  }

  Future<List<Mob>> getAllUserAssignedMobs() async {
    final url = '$_baseUrl/assigneduser';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Mob.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch mobs');
    }
  }

  Future<List<Mob>> getAllUnassignedUserMobs() async {
    final url = '$_baseUrl/notassigneduser';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Mob.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch mobs');
    }
  }

  Future<List<Mob>> getAllMobsWithDroneAssigned() async {
    final url = '$_baseUrl/withdrone';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Mob.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch mobs');
    }
  }

  Future<List<Mob>> getAllMobsWithoutDroneAssigned() async {
    final url = '$_baseUrl/withoutdrone';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Mob.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch mobs');
    }
  }
  Future<bool> addMob(Mob mob) async {
    final url = '$_baseUrl/addmob';
    final res = await http.post(Uri.parse(url),body: mob.toJson());
    if(res.statusCode == 200){
      return true;
    }
    return false;
  }
}
