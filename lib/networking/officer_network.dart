import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mob_monitoring_flutter/models/user.dart';

import '../models/ip_address.dart';
class OfficerNetwork {
  static Future<List<User>> GetOfficersWithoutMobs() async {
    String url = "https://${IPAddress.getIP()}/api/officer/getofficerswithoutmobs";
    var response = await http.get(Uri.parse(url));
    final List<dynamic> jsonList = json.decode(response.body);
    List<User> l = [];
    for (var i in jsonList) {
      User u = User.fromJson(i);
      l.add(u);
      //l.add(u)
    }
    return l;
  }
}