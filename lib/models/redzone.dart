class Redzone{
  int? id;
  String name;
  bool isActive;
  Redzone({required this.id, required this.name, required this.isActive});
  Redzone.createObj({required this.name, required this.isActive});
  factory Redzone.fromJson(Map<String, dynamic> json) {
    return Redzone(
      id: json['id'],
      name: json['name'],
      isActive: int.parse(json['isActive']) == 1 ? true : false,
    );
  }
  Map<String, dynamic> toJson() => {
    'name': name,
    'isActive': isActive.toString(),
  };
}