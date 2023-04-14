class Mob {
  int? mobID;
  String? name;
  String? startDate;
  String? endDate;
  int? proputedStrength;
  int? actualStrength;
  bool? isActive;
  double? mobStartLat;
  double? mobStartLon;
  double? mobEndLat;
  double? mobEndLon;

  Mob({
    this.mobID,
    this.name,
    this.startDate,
    this.endDate,
    this.proputedStrength,
    this.actualStrength,
    this.isActive,
    this.mobStartLat,
    this.mobStartLon,
    this.mobEndLat,
    this.mobEndLon,
  });

  factory Mob.fromJson(Map<String, dynamic> json) => Mob(
        mobID: json['MobID'],
        name: json['Name'],
        startDate: json['StartDate'].toString(),
        endDate: json['EndDate'].toString(),
        proputedStrength: json['ProputedStrength'],
        actualStrength: json['ActualStrength'],
        isActive: json['IsActive'],
        mobStartLat: json['MobStartLat'],
        mobStartLon: json['MobStartLon'],
        mobEndLat: json['MobEndLat'],
        mobEndLon: json['MobEndLon'],
      );

  Map<String, dynamic> toJson() => {
        'Name': name,
        'StartDate': startDate,
        'EndDate': endDate,
        'ProputedStrength': proputedStrength.toString(),
        'IsActive': isActive.toString(),
        'MobStartLat': mobStartLat.toString(),
        'MobStartLon': mobStartLon.toString(),
      };
}
