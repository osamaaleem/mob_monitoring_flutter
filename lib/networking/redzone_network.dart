import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mob_monitoring_flutter/models/ip_address.dart';
import '../models/redzone.dart';
import '../models/redzone_coordinates.dart';

class RedzoneNetwork {
  final String _baseUrl = "https://${IPAddress.getIP()}/api/redzones";
  //final String _baseUrl = "https://192.168.1.5/api/mobs";


  Future<int> getRedzoneIdByName(String name) async {
    final url = '$_baseUrl/GetRedZoneIdByName?name=$name';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      // if(kDebugMode){
      //   var json = jsonDecode(response.body);
      //   print(json[0]);
      // }
      return json[0];
    } else {
      throw Exception();
    }
  }
  Future<List<Redzone>> getAllZones() async {
    final url = '$_baseUrl/getallzones';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Redzone.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch mobs');
    }
  }
  Future<Redzone> getRedzoneByMobId(int id){
    final url = '$_baseUrl/getzonebymobid/$id';
    return http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        return Redzone.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch mob');
      }
    });
  }
  Future<Redzone> getRedzoneByName(String name){
    final url = '$_baseUrl/getzonebyname/$name';
    return http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        return Redzone.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch mob');
      }
    });
  }
  Future<bool> addRedzoneCoords(List<RedZoneCoordinates> coords){
    final url = '$_baseUrl/addredzonecoords';
    return http.post(Uri.parse(url), body: json.encode(coords.map((e) => e.toJson()).toList())).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to fetch mob');
      }
    });
  }
  Future<List<RedZoneCoordinates>> getRedzoneCoordsById(int zoneId){
    final url = '$_baseUrl/getredzonecoordsbyid/$zoneId';
    return http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => RedZoneCoordinates.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch coords');
      }
    });
  }
  Future<List<Redzone>> getActiveZones(){
    final url = '$_baseUrl/getactivezones';
    return http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Redzone.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch coords');
      }
    });
  }
  Future<List<Redzone>> getInActiveZones(){
    final url = '$_baseUrl/getinactivezones';
    return http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Redzone.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch coords');
      }
    });
  }
  Future<bool> addRedzone(Redzone r){
    final url = '$_baseUrl/addredzone';
    return http.post(Uri.parse(url), body: r.toJson()).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add mob');
      }
    });
  }
  Future<bool> deleteRedzone(int id){
    final url = '$_baseUrl/deleteredzone/$id';
    return http.delete(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to fetch mob');
      }
    });
  }
  Future<bool> updateRedzone(Redzone r){
    final url = '$_baseUrl/updateredzone';
    return http.put(Uri.parse(url), body: json.encode(r.toJson())).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to fetch mob');
      }
    });
  }
 }
