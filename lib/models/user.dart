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
}