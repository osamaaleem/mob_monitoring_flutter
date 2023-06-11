class Drone {
  int? droneId;
  String name;
  bool isAvailable;
  double battery;
  bool isCharged;
  int bufferSize;
  Drone(
      {required this.name,
      required this.isAvailable,
      required this.battery,
      required this.isCharged,
      required this.bufferSize});
  Drone.all(
      {
      required this.droneId,
        required this.name,
        required this.isAvailable,
        required this.battery,
        required this.isCharged,
        required this.bufferSize});
  Map toJson() => {
        'Name': name,
        'IsAvailable': isAvailable.toString(),
        'Battery': battery.toString(),
        'IsCharged': isCharged.toString(),
        'BufferSizeMb': bufferSize.toString()
      };
  static Drone fromJson(Map<String, dynamic> json) => Drone.all(
      droneId: int.parse(json['DroneId'].toString()),
      name: json['Name'].toString(),
      isAvailable: json['IsAvailable'].toString() == 'true'? true:false,
      battery: double.parse(json['Battery'].toString()),
      isCharged: json['IsCharged'].toString() == 'true'? true: false,
      bufferSize: int.parse(json['BufferSizeMb'].toString()));
}
