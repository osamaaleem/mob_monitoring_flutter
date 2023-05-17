import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ip_address.dart';
import '../models/user.dart';

class ManagementNetwork{
  static Future<List<User>> getAllOperators() async {
    String url = "https://${IPAddress.getIP()}/api/management/getoperators";
    var response = await http.get(Uri.parse(url));
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

  static Future<List<User>> getAllOfficer() async {
    String url = "https://${IPAddress.getIP()}/api/management/getofficers";
    var response = await http.get(Uri.parse(url));
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => User.fromJson(json)).toList();
  }
  // Post mobID and userID to assign user to mob
  static Future<bool> allocateMobToOperator(int mobId, int userId) async {
    String url = "https://${IPAddress.getIP()}/api/management/allocatemobtooperator";
    var response = await http.post(Uri.parse(url), body: {
      "mobId": mobId.toString(),
      "userId": userId.toString()
    });
    return response.statusCode == 200? true:false;
  }

  static Future<bool> allocateMobToOfficer(int mobId, int userId) async {
    String url = "https://${IPAddress.getIP()}/api/management/allocatemobtoofficer";
    var response = await http.post(Uri.parse(url), body: {
      "mobId": mobId.toString(),
      "userId": userId.toString()
    });
    return response.statusCode == 200? true:false;
  }
}