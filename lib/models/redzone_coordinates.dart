import 'dart:convert';

class RedZoneCoordinates {
  int? coordinateID;
  int? redZoneID_FK;
  double? redZoneLat;
  double? redZoneLon;

  RedZoneCoordinates({
    this.coordinateID,
    this.redZoneID_FK,
    this.redZoneLat,
    this.redZoneLon,
  });

  factory RedZoneCoordinates.fromJson(Map<String, dynamic> json) {
    return RedZoneCoordinates(
      coordinateID: json['CoordinateID'],
      redZoneID_FK: json['RedZoneID_FK'],
      redZoneLat: json['RedZoneLat'],
      redZoneLon: json['RedZoneLon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CoordinateID': coordinateID,
      'RedZoneID_FK': redZoneID_FK,
      'RedZoneLat': redZoneLat,
      'RedZoneLon': redZoneLon,
    };
  }

  static List<RedZoneCoordinates> listFromJson(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<RedZoneCoordinates>((json) => RedZoneCoordinates.fromJson(json)).toList();
  }

  static String listToJson(List<RedZoneCoordinates> coordinates) {
    final List<Map<String, dynamic>> jsonData =
    coordinates.map<Map<String, dynamic>>((coord) => coord.toJson()).toList();
    return json.encode(jsonData);
  }
}
