class ModelName {
  int detailID;
  int? mobIDFK;
  int? droneIDFK;
  int? usersIDFK;

  ModelName({
    required this.detailID,
    this.mobIDFK,
    this.droneIDFK,
    this.usersIDFK,
  });

  factory ModelName.fromJson(Map<String, dynamic> json) {
    return ModelName(
      detailID: json['DetailID'],
      mobIDFK: json['MobID_FK'],
      droneIDFK: json['DroneID_FK'],
      usersIDFK: json['UsersID_FK'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DetailID'] = detailID.toString();
    data['MobID_FK'] = mobIDFK.toString();
    data['DroneID_FK'] = droneIDFK.toString();
    data['UsersID_FK'] = usersIDFK.toString();
    return data;
  }
}
