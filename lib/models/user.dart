class User{
  int? id;
  String name;
  String email;
  String password;
  String organization;
  String role;
  User.all({required this.name,required this.email,required this.password,required this.organization,required this.role, required int id});
  User.forRegister({required this.name,required this.email,required this.password,required this.organization,required this.role});
  Map toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'organization': organization,
    'role': role
  };
  factory User.fromJson(Map<String, dynamic> json) {
    return User.all(
      id: int.parse(json['UserID'].toString()),
      name: json['Name'].toString(),
      email: json['Email'].toString(),
      password: json['Password'].toString(),
      organization: json['Organization'].toString(),
      role: json['Role'].toString(),
    );
  }

}