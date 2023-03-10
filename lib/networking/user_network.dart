

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mob_monitoring_flutter/models/user.dart';

class UserNetwork{
  static Future<http.Response> registerUser(User user) async {
    String url = "https://localhost:44381/api/users/register";
    var uri = Uri.parse(url);
    if(kDebugMode){
      print(uri);
    }
    var res = await http.post(uri,
        body: user.toJson()
    );
    return res;
  }
  static Future<http.Response> login(String email,String password) async {
    String url = "https://localhost:44381/api/users/login";
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
}