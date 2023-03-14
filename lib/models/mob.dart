class Mob {
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  int? proputedStrength;
  int? actualStrength;
  bool? isActive;
  double? mobStartLat;
  double? mobStartLon;
  double? mobEndLat;
  double? mobEndLon;

  Mob({
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
      name: json['Name'],
    startDate: json['StartDate'] != null
        ? DateTime.parse(json['StartDate'])
        : null,
    endDate:
    json['EndDate'] != null ? DateTime.parse(json['EndDate']) : null,
    proputedStrength: json['ProputedStrength'],
    actualStrength: json['ActualStrength'],
    isActive: json['IsActive'],
    mobStartLat: json['MobStartLat'],
    mobStartLon: json['MobStartLon'],
    mobEndLat: json['MobEndLat'],
    mobEndLon: json['MobEndLon'],
  );

  Map<String, dynamic> toJson() => {
    'StartDate': startDate?.toIso8601String(),
    'EndDate': endDate?.toIso8601String(),
    'ProputedStrength': proputedStrength,
    'ActualStrength': actualStrength,
    'IsActive': isActive,
    'MobStartLat': mobStartLat,
    'MobStartLon': mobStartLon,
    'MobEndLat': mobEndLat,
    'MobEndLon': mobEndLon,
  };
}
