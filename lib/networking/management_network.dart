import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ip_address.dart';
import '../models/management.dart';

class ManagementNetwork{
  final String _baseUrl = "https://${IPAddress.getIP()}/api/Management";
  Future<Management> getManagementData() async {
    final url = '$_baseUrl/get';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final dynamic jsonList = json.decode(response.body);
      return jsonList.map((json) => Management.fromJson(json));
    }
    else{
      throw Exception('Failed to fetch data');
    }
  }
  Future<bool> setManagementData() async {

    return false;
  }
}