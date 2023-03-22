import 'dart:convert';

class Management {
  List<String> mobs;
  List<String> users;
  List<String> operators;
  List<String> drones;
  List<String> redZones;

  Management({
    required this.mobs,
    required this.users,
    required this.operators,
    required this.drones,
    required this.redZones,
  });

  factory Management.fromJson(Map<String, dynamic> json) {
    return Management(
      mobs: List<String>.from(json['Mobs']),
      users: List<String>.from(json['Users']),
      operators: List<String>.from(json['Operators']),
      drones: List<String>.from(json['Drones']),
      redZones: List<String>.from(json['RedZones']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Mobs'] = mobs;
    data['Users'] = users;
    data['Operators'] = operators;
    data['Drones'] = drones;
    data['RedZones'] = redZones;
    return data;
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  static Management fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Management.fromJson(jsonMap);
  }
}
