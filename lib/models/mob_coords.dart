import 'dart:convert';

class MobCoordinates {
  int? coordinateID;
  int? MobID_FK;
  double? MobLat;
  double? MobLon;

  MobCoordinates({
    this.coordinateID,
    this.MobID_FK,
    this.MobLat,
    this.MobLon,
  });

  factory MobCoordinates.fromJson(Map<String, dynamic> json) {
    return MobCoordinates(
      coordinateID: json['CoordinateID'],
      MobID_FK: json['MobID_FK'],
      MobLat: json['MobLat'],
      MobLon: json['MobLon'],
    );
  }

  factory MobCoordinates.preDefFromJson(Map<String,dynamic> json){
    return MobCoordinates(
      coordinateID: json['CoordinateID'],
      MobID_FK: json['MobID_FK'],
      MobLat: json['PreDefLat'],
      MobLon: json['PreDefLon'],
    );
  }

  Map<String, dynamic> preDefToJson(){
    return {
      'CoordinateID': coordinateID,
      'MobID_FK': MobID_FK,
      'PreDeflat': MobLat,
      'PreDefLon': MobLon,
    };
  }
  Map<String, dynamic> toJson() {
    return {
      'CoordinateID': coordinateID,
      'MobID_FK': MobID_FK,
      'MobLat': MobLat,
      'MobLon': MobLon,
    };
  }

  static List<MobCoordinates> listFromJson(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<MobCoordinates>((json) => MobCoordinates.fromJson(json)).toList();
  }

  static String listToJson(List<MobCoordinates> coordinates) {
    final List<Map<String, dynamic>> jsonData =
    coordinates.map<Map<String, dynamic>>((coord) => coord.toJson()).toList();
    return json.encode(jsonData);
  }
}
