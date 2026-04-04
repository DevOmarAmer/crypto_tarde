

class UserModel {
  final String id;
  final String email;
  final String phone;
  final String password;
  final String name;

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'password': password,
      'name': name,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
