class Drone {
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
  Map toJson() => {
        'name': name,
        'isAvailable': isAvailable,
        'battery': battery,
        'isCharged': isCharged,
        'bufferSize': bufferSize
      };
  static Drone fromJson(Map<String, dynamic> json) => Drone(
      name: json['name'].toString(),
      isAvailable: json['isAvailable'],
      battery: double.parse(json['battery']),
      isCharged: json['isCharged'],
      bufferSize: int.parse(json['bufferSize']));
}
