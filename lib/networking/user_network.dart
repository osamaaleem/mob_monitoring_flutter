import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mob_monitoring_flutter/models/ip_address.dart';
import 'package:mob_monitoring_flutter/models/user.dart';

class UserNetwork{
  static Future<http.Response> registerUser(User user) async {
    String url = "https://${IPAddress.getIP()}/api/users/register";
    var uri = Uri.parse(url);
    if(kDebugMode){
      print(uri);
    }
    var res = await http.post(uri,
        body: user.toJson()
    );
    return res;
  }
  static Future<List<User>> getAllUsers() async {
    String url = "https://${IPAddress.getIP()}/api/users/getallusers";
    var response = await http.get(Uri.parse(url));
    final List<dynamic> jsonList = json.decode(response.body);
    //return json.decode(response.body);
    List<User> l = [];
    for(var i in jsonList){
       User u = User.fromJson(i);
       l.add(u);
      //l.add(u)
    }
    return l;
    //return jsonList.map((json) => User.fromJson(json)).toList();

  }static Future<http.Response> login(String email,String password) async {
    String url = "https://${IPAddress.getIP()}/api/users/login";
    var uri = Uri.parse(url);
    if(kDebugMode){
      print(uri);
    }
    var res = await http.post(uri,
        body: {
          "Email": email,
          "Password": password
        }
    );
    if (kDebugMode) {
      print("Response Body: ${res.body}");
    }
    return res;
  }
  static Future<http.Response> UpdateUser(User user) async {
    String url = "https://${IPAddress.getIP()}/api/users/updateuser";
    var uri = Uri.parse(url);
    if(kDebugMode){
      print(uri);
    }
    var res = await http.post(uri,
        body: user.toJson()
    );
    return res;
  }
  static Future<http.Response> DeleteUser(int userId){
    String url = "https://${IPAddress.getIP()}/api/users/deleteuser?id=$userId";
    var uri = Uri.parse(url);
    if(kDebugMode){
      print(uri);
    }
    return http.get(uri);
  }
}