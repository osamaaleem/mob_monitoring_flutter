class User{
  String name;
  String email;
  String password;
  String organization;
  String role;
  User.all({required this.name,required this.email,required this.password,required this.organization,required this.role});
  Map toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'organization': organization,
    'role': role
  };
  factory User.fromJson(Map<String, dynamic> json) {
    return User.all(
      name: json['name'].toString(),
      email: json['email'].toString(),
      password: json['password'].toString(),
      organization: json['organization'].toString(),
      role: json['role'].toString(),
    );
  }

}