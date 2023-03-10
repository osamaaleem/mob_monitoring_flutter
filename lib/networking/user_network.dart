
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mob_monitoring_flutter/models/user.dart';

class UserNetwork{
  static Future<http.Response> registerUser(User user) async {
    String url = "https://localhost:44324/api/user/register";
    var uri = Uri.parse(url);
    if(kDebugMode){
      print(uri);
    }
    var res = await http.post(uri,
        body: user.toJson()
    );
    if (kDebugMode) {
      print(jsonDecode(res.body));
    }
    return res;
  }
}