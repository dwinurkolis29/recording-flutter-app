import 'safe_convert.dart';

class User {
  final String username;
  final String email;
  final String phone;
  final String address;
  final String password;

  User({
    this.username = "",
    this.email = "",
    this.phone = "",
    this.address = "",
    this.password = "",
  });

  factory User.fromJson(Map<String, dynamic>? json) => User(
    username: asString(json, 'username'),
    email: asString(json, 'email'),
    phone: asString(json, 'phone'),
    address: asString(json, 'address'),
    password: asString(json, 'password'),
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'phone': phone,
    'address': address,
    'password': password,
  };

  User copyWith({
    String? username,
    String? email,
    String? phone,
    String? address,
    String? password,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      password: password ?? this.password,
    );
  }
}

